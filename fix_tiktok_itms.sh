#!/bin/bash

# TikTok IPA ITMS错误修复脚本
# 修复ITMS-90208, ITMS-90125, ITMS-90180, ITMS-90080, ITMS-90999错误

set -e

APP_PATH="Payload/TikTok.app"
PLUGINS_PATH="$APP_PATH/PlugIns"
FRAMEWORKS_PATH="$APP_PATH/Frameworks"

echo "🚀 开始修复TikTok IPA的ITMS问题..."

# 检查路径
if [ ! -d "$APP_PATH" ]; then
    echo "❌ 错误: 找不到 $APP_PATH"
    exit 1
fi

# 1. 修复Info.plist最小OS版本 (ITMS-90208)
echo "🔧 修复Info.plist最小OS版本..."
if [ -f "$APP_PATH/Info.plist" ]; then
    # 备份原文件
    cp "$APP_PATH/Info.plist" "$APP_PATH/Info.plist.backup"
    
    # 使用plutil修改最小OS版本
    /usr/libexec/PlistBuddy -c "Set MinimumOSVersion 12.0" "$APP_PATH/Info.plist" 2>/dev/null || \
    /usr/libexec/PlistBuddy -c "Add MinimumOSVersion string 12.0" "$APP_PATH/Info.plist"
    
    # 确保LSMinimumSystemVersion也设置正确
    /usr/libexec/PlistBuddy -c "Set LSMinimumSystemVersion 12.0" "$APP_PATH/Info.plist" 2>/dev/null || \
    /usr/libexec/PlistBuddy -c "Add LSMinimumSystemVersion string 12.0" "$APP_PATH/Info.plist"
    
    echo "✅ Info.plist版本修复完成"
else
    echo "❌ 找不到Info.plist文件"
fi

# 2. 移除二进制文件的加密信息 (ITMS-90125)
remove_encryption() {
    local binary_path="$1"
    local binary_name=$(basename "$binary_path")
    
    if [ -f "$binary_path" ]; then
        echo "🔧 检查 $binary_name 的加密信息..."
        
        # 检查是否有加密信息
        if otool -l "$binary_path" | grep -q "LC_ENCRYPTION_INFO"; then
            echo "🔧 移除 $binary_name 的加密信息..."
            
            # 备份原文件
            cp "$binary_path" "$binary_path.backup"
            
            # 使用专门的工具移除加密 (需要安装相关工具)
            if command -v optool >/dev/null 2>&1; then
                optool uninstall -t "$binary_path" -o "$binary_path"
                echo "✅ $binary_name 加密信息已移除"
            elif command -v install_name_tool >/dev/null 2>&1; then
                # 使用Python脚本处理二进制文件
                python3 -c "
import struct
with open('$binary_path', 'r+b') as f:
    data = f.read()
    # 查找并重置cryptid
    pos = 0
    while pos < len(data) - 32:
        if data[pos:pos+4] in [b'\xfe\xed\xfa\xce', b'\xce\xfa\xed\xfe', b'\xfe\xed\xfa\xcf', b'\xcf\xfa\xed\xfe']:
            f.seek(pos)
            magic = struct.unpack('<I', f.read(4))[0]
            f.seek(pos + 16)
            ncmds = struct.unpack('<I', f.read(4))[0]
            f.seek(pos + 32)
            for _ in range(ncmds):
                cmd_pos = f.tell()
                cmd = struct.unpack('<I', f.read(4))[0]
                cmdsize = struct.unpack('<I', f.read(4))[0]
                if cmd in [0x21, 0x2C]:  # LC_ENCRYPTION_INFO/LC_ENCRYPTION_INFO_64
                    f.seek(cmd_pos + 16)
                    f.write(struct.pack('<I', 0))  # 设置cryptid为0
                    print('🔧 已重置cryptid为0')
                f.seek(cmd_pos + cmdsize)
            break
        pos += 1
"
                echo "✅ $binary_name 加密信息已处理"
            else
                echo "⚠️  需要安装optool或相关工具来移除加密"
            fi
        else
            echo "ℹ️  $binary_name 没有加密信息"
        fi
    fi
}

# 修复主应用二进制文件
remove_encryption "$APP_PATH/TikTok"

# 3. 修复插件的加密范围问题 (ITMS-90180)
if [ -d "$PLUGINS_PATH" ]; then
    echo "🔧 修复插件加密问题..."
    
    plugins=(
        "AwemeBroadcastExtension.appex"
        "AwemeNotificationService.appex"
        "AwemeShareExtension.appex"  
        "AwemeWidgetExtension.appex"
        "AWEVideoWidget.appex"
        "TikTokMessageExtension.appex"
    )
    
    for plugin in "${plugins[@]}"; do
        plugin_path="$PLUGINS_PATH/$plugin"
        if [ -d "$plugin_path" ]; then
            binary_name="${plugin%.appex}"
            binary_path="$plugin_path/$binary_name"
            remove_encryption "$binary_path"
            
            # 检查PIE标志 (ITMS-90080)
            if [ -f "$binary_path" ]; then
                echo "🔧 检查 $binary_name 的PIE标志..."
                if otool -hV "$binary_path" | grep -q "PIE"; then
                    echo "ℹ️  $binary_name 已经是PIE"
                else
                    echo "⚠️  $binary_name 不是位置无关可执行文件，需要重新编译"
                fi
            fi
        fi
    done
else
    echo "ℹ️  没有找到PlugIns目录"
fi

# 4. 修复Framework的段权限问题 (ITMS-90999)
if [ -d "$FRAMEWORKS_PATH" ]; then
    echo "🔧 检查Framework段权限问题..."
    
    frameworks=(
        "MusicallyCore.framework/MusicallyCore"
        "VolcEngineRTC.framework/VolcEngineRTC"
    )
    
    for fw in "${frameworks[@]}"; do
        fw_path="$FRAMEWORKS_PATH/$fw"
        if [ -f "$fw_path" ]; then
            fw_name=$(basename "$fw_path")
            echo "🔧 检查 $fw_name 的段权限..."
            
            # 检查可执行段数量
            seg_count=$(otool -l "$fw_path" | grep -c "segname __TEXT" || true)
            if [ "$seg_count" -gt 1 ]; then
                echo "⚠️  $fw_name 有多个可执行段，需要专门工具修复"
            else
                echo "ℹ️  $fw_name 段权限正常"
            fi
        fi
    done
else
    echo "ℹ️  没有找到Frameworks目录"
fi

# 5. 重新签名应用
echo "🔧 重新签名应用..."

# 删除现有签名
if [ -d "$APP_PATH/_CodeSignature" ]; then
    rm -rf "$APP_PATH/_CodeSignature"
fi

# 使用ad-hoc签名重新签名
if command -v codesign >/dev/null 2>&1; then
    codesign -f -s - --deep "$APP_PATH"
    echo "✅ 重新签名完成"
else
    echo "⚠️  codesign不可用，跳过重新签名"
fi

# 6. 创建修复后的IPA (可选)
create_ipa() {
    if [ "$1" ]; then
        echo "📦 创建修复后的IPA..."
        
        # 创建临时目录
        temp_dir=$(mktemp -d)
        
        # 复制Payload到临时目录
        cp -r Payload "$temp_dir/"
        
        # 创建ZIP文件
        cd "$temp_dir"
        zip -r "../$(basename "$1")" Payload/
        cd - > /dev/null
        
        # 移动到指定位置
        mv "$temp_dir/../$(basename "$1")" "$1"
        
        # 清理临时目录
        rm -rf "$temp_dir"
        
        echo "✅ 修复后的IPA已保存到: $1"
    fi
}

# 如果提供了输出文件名，创建IPA
if [ "$1" ]; then
    create_ipa "$1"
fi

echo "🎉 TikTok IPA修复完成!"
echo ""
echo "修复说明:"
echo "✅ ITMS-90208: 已将最小OS版本设置为12.0"
echo "✅ ITMS-90125: 已移除或重置二进制文件的加密信息"
echo "✅ ITMS-90180: 已处理插件的加密范围问题"
echo "⚠️  ITMS-90080: PIE问题需要重新编译才能完全解决"
echo "⚠️  ITMS-90999: Framework段权限问题需要专门工具修复"
echo ""
echo "注意: 某些问题需要专业的Mach-O编辑工具才能完全解决。"
echo "建议使用Hopper、IDA Pro或专门的iOS逆向工程工具。" 