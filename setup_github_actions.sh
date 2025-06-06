#!/bin/bash

# GitHub Actions快速设置脚本
# 用于配置TikTok IPA ITMS错误修复的GitHub Actions工作流

set -e

echo "🚀 GitHub Actions TikTok IPA修复工具快速设置"
echo "============================================="

# 检查是否在git仓库中
if [ ! -d ".git" ]; then
    echo "❌ 错误: 当前目录不是Git仓库"
    echo "请先运行: git init"
    exit 1
fi

# 创建必要的目录结构
echo "📁 创建目录结构..."
mkdir -p .github/workflows

# 检查是否已存在工作流文件
if [ -f ".github/workflows/fix-itms-issues.yml" ]; then
    echo "⚠️  工作流文件已存在，是否覆盖? (y/N)"
    read -r response
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        echo "跳过工作流文件创建"
    else
        echo "✅ 工作流文件已更新"
    fi
else
    echo "✅ 工作流文件已创建"
fi

# 检查Python和Bash修复脚本
if [ ! -f "fix_itms_issues.py" ]; then
    echo "⚠️  缺少Python修复脚本 (fix_itms_issues.py)"
    echo "请确保该文件存在于仓库根目录"
fi

if [ ! -f "fix_tiktok_itms.sh" ]; then
    echo "⚠️  缺少Bash修复脚本 (fix_tiktok_itms.sh)"
    echo "请确保该文件存在于仓库根目录"
fi

# 检查IPA文件或Payload目录
echo ""
echo "📱 检查IPA文件..."
if [ -d "Payload" ]; then
    echo "✅ 找到Payload目录"
    if [ -d "Payload/TikTok.app" ]; then
        echo "✅ 找到TikTok.app"
        
        # 显示应用信息
        if [ -f "Payload/TikTok.app/Info.plist" ]; then
            echo "📋 应用信息:"
            echo "   Bundle ID: $(plutil -p Payload/TikTok.app/Info.plist | grep CFBundleIdentifier | cut -d'"' -f4)"
            echo "   版本: $(plutil -p Payload/TikTok.app/Info.plist | grep CFBundleShortVersionString | cut -d'"' -f4)"
            echo "   最小OS: $(plutil -p Payload/TikTok.app/Info.plist | grep MinimumOSVersion | cut -d'"' -f4 || echo '未设置')"
        fi
    else
        echo "❌ Payload目录中没有找到TikTok.app"
    fi
else
    echo "⚠️  没有找到Payload目录"
    echo "您可以:"
    echo "1. 解压IPA文件到当前目录"
    echo "2. 或在运行Actions时提供IPA下载链接"
fi

# 创建.gitignore (如果不存在)
if [ ! -f ".gitignore" ]; then
    echo ""
    echo "📝 创建.gitignore文件..."
    cat > .gitignore << 'EOF'
# 临时文件
*.backup
*.original
*.tmp
*.log

# 系统文件
.DS_Store
Thumbs.db

# 修复后的文件
*_Fixed.ipa
fix_report.md

# Python缓存
__pycache__/
*.pyc
*.pyo

# 个人配置
.vscode/
.idea/
EOF
    echo "✅ .gitignore文件已创建"
fi

# 检查仓库远程配置
echo ""
echo "🔗 检查Git配置..."
remote_url=$(git remote get-url origin 2>/dev/null || echo "")
if [ -n "$remote_url" ]; then
    echo "✅ 远程仓库: $remote_url"
else
    echo "⚠️  没有配置远程仓库"
    echo "请添加GitHub远程仓库:"
    echo "git remote add origin https://github.com/用户名/仓库名.git"
fi

# 提供使用指南
echo ""
echo "📚 使用指南"
echo "=========="
echo ""
echo "1. 提交并推送代码到GitHub:"
echo "   git add ."
echo "   git commit -m '添加ITMS修复工具'"
echo "   git push"
echo ""
echo "2. 在GitHub网站上:"
echo "   - 进入仓库页面"
echo "   - 点击 'Actions' 标签"
echo "   - 选择 '修复TikTok IPA的ITMS问题' 工作流"
echo "   - 点击 'Run workflow'"
echo ""
echo "3. 配置选项:"
echo "   - IPA URL: 留空(使用仓库中的Payload)或输入下载链接"
echo "   - 修复选项: 保持默认设置"
echo "   - 点击绿色的 'Run workflow' 按钮"
echo ""
echo "4. 下载结果:"
echo "   - 等待工作流完成(约5-10分钟)"
echo "   - 在工作流页面下载Artifacts:"
echo "     * TikTok-Fixed-IPA: 修复后的IPA文件"
echo "     * Fix-Report: 修复报告"
echo "     * Fix-Logs: 详细日志"

# 安全提醒
echo ""
echo "🛡️  安全提醒"
echo "==========="
echo "- 建议使用私有仓库进行修复操作"
echo "- 不要在公开仓库中包含敏感的IPA文件"
echo "- 及时删除不需要的Artifacts"
echo "- 遵守相关法律法规，仅用于学习研究"

# 检查文件权限
echo ""
echo "🔧 设置文件权限..."
if [ -f "fix_tiktok_itms.sh" ]; then
    chmod +x fix_tiktok_itms.sh
    echo "✅ 已设置fix_tiktok_itms.sh为可执行"
fi

if [ -f "fix_itms_issues.py" ]; then
    chmod +x fix_itms_issues.py
    echo "✅ 已设置fix_itms_issues.py为可执行"
fi

echo ""
echo "🎉 设置完成!"
echo ""
echo "接下来您可以:"
echo "1. 检查所有文件是否正确"
echo "2. 提交代码到GitHub"
echo "3. 运行GitHub Actions工作流"
echo ""
echo "如需帮助，请查看 GitHub_Actions_使用指南.md" 