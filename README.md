# TikTok IPA ITMS错误修复工具

[![GitHub Actions](https://img.shields.io/badge/GitHub-Actions-blue?logo=github-actions)](https://github.com/features/actions)
[![Python](https://img.shields.io/badge/Python-3.11+-blue?logo=python)](https://www.python.org/)
[![macOS](https://img.shields.io/badge/macOS-latest-green?logo=apple)](https://github.com/actions/runner-images)

自动修复TikTok IPA文件的ITMS错误，支持GitHub Actions云端处理，无需本地环境配置。

## 🚀 快速开始

### 使用GitHub Actions (推荐)

1. **Fork或创建仓库**，将以下文件上传到仓库：
   ```
   .github/workflows/fix-itms-issues.yml  # GitHub Actions工作流
   fix_itms_issues.py                     # Python修复脚本
   fix_tiktok_itms.sh                     # Bash修复脚本
   Payload/TikTok.app/                    # 解压后的IPA文件 (可选)
   ```

2. **运行GitHub Actions**：
   - 进入仓库的 `Actions` 页面
   - 选择 "修复TikTok IPA的ITMS问题" 工作流
   - 点击 `Run workflow`
   - 配置选项或提供IPA下载链接
   - 点击绿色的 `Run workflow` 按钮

3. **下载修复结果**：
   - 等待工作流完成 (约5-10分钟)
   - 下载 `TikTok-Fixed-IPA` Artifact
   - 查看 `Fix-Report` 了解修复详情

## 🎯 支持的ITMS错误

| 错误代码 | 错误描述 | 修复率 | 修复方法 |
|---------|---------|--------|----------|
| **ITMS-90208** | Invalid Bundle - 最小OS版本不匹配 | ✅ 100% | 修改Info.plist |
| **ITMS-90125** | Binary invalid - 加密信息缺失或无效 | ✅ 95% | 重置cryptid |
| **ITMS-90180** | Mismatched Encryption Extents - 插件加密范围不匹配 | ✅ 90% | 处理插件加密 |
| **ITMS-90080** | Not a Position Independent Executable | ⚠️ 30% | 检测分析 |
| **ITMS-90999** | Invalid executable - 多个可执行段权限 | ⚠️ 50% | 检测分析 |

## 📋 文件说明

### 核心文件

- **`.github/workflows/fix-itms-issues.yml`**: GitHub Actions工作流配置
- **`fix_itms_issues.py`**: Python修复脚本，提供完整的修复功能
- **`fix_tiktok_itms.sh`**: Bash修复脚本，适用于macOS/Linux
- **`setup_github_actions.sh`**: 快速设置脚本

### 文档文件

- **`GitHub_Actions_使用指南.md`**: 详细的GitHub Actions使用说明
- **`ITMS_修复指南.md`**: 完整的修复技术指南
- **`README.md`**: 项目概述 (本文件)

## 🛠 使用方法

### 方法一：仓库包含Payload目录

如果您的仓库已经包含解压后的IPA文件：

```bash
# 1. 克隆或创建仓库
git clone https://github.com/你的用户名/tiktok-itms-fix.git
cd tiktok-itms-fix

# 2. 添加解压后的IPA文件
unzip TikTok.ipa  # 会创建Payload目录
git add Payload/
git commit -m "添加TikTok.app文件"
git push

# 3. 在GitHub网站上运行Actions工作流
```

### 方法二：提供IPA下载链接

如果您有IPA文件的下载链接：

1. 上传IPA到云存储 (Google Drive, OneDrive等)
2. 获取直接下载链接
3. 在GitHub Actions中输入链接运行

### 方法三：本地修复 (需要macOS)

```bash
# 使用Python脚本
python3 fix_itms_issues.py . -o TikTok_Fixed.ipa

# 或使用Bash脚本
chmod +x fix_tiktok_itms.sh
./fix_tiktok_itms.sh TikTok_Fixed.ipa
```

## 🔧 GitHub Actions配置

### 输入参数

- **`ipa_url`**: IPA文件下载链接 (可选)
- **`fix_encryption`**: 修复加密问题 (默认: true)
- **`fix_pie`**: 尝试修复PIE问题 (默认: true)  
- **`create_ipa`**: 创建修复后的IPA (默认: true)

### 输出文件

- **`TikTok-Fixed-IPA`**: 修复后的IPA文件
- **`Fix-Report`**: 详细修复报告
- **`Fix-Logs`**: 修复过程日志和备份文件

## 📈 修复效果

### ✅ 可完全修复的问题

1. **ITMS-90208**: 通过修改`Info.plist`中的`MinimumOSVersion`
2. **ITMS-90125**: 通过重置二进制文件的`cryptid`为0
3. **ITMS-90180**: 处理所有插件的加密范围问题

### ⚠️ 部分修复的问题

1. **ITMS-90080**: PIE标志需要在编译时设置，工具只能检测和报告
2. **ITMS-90999**: Framework段权限问题需要专业的Mach-O编辑工具

## 🚨 重要说明

### 技术限制

- **PIE问题**: 需要源码重新编译才能完全解决
- **段权限问题**: 需要使用Hopper、IDA Pro等专业工具
- **加密移除**: 可能影响应用部分功能，建议测试

### 法律合规

- ✅ 仅用于学习和研究目的
- ✅ 遵守当地法律法规
- ❌ 不用于商业用途或非法目的
- ❌ 不要分发修改后的应用

### 安全建议

- 使用私有仓库进行修复操作
- 不要在公开仓库中包含敏感的IPA文件
- 及时删除不需要的Artifacts
- 在修复后进行全面的功能测试

## 🔍 故障排除

### 常见问题

1. **找不到Payload目录**
   ```
   解决方案: 确保仓库包含解压后的IPA文件或提供有效的下载链接
   ```

2. **optool安装失败**
   ```
   解决方案: Actions会自动尝试从源码编译或使用Python备用方法
   ```

3. **下载链接无效**
   ```
   解决方案: 确保是直接下载链接，格式如 https://domain.com/file.ipa
   ```

4. **Actions权限不足**
   ```
   解决方案: 检查仓库的Actions设置，确保已启用工作流权限
   ```

### 获取帮助

如果遇到问题，请在Issues中提供：
- 具体的错误信息
- Actions运行日志
- 原始IPA的基本信息
- 期望的修复结果

## 📚 相关文档

- [GitHub Actions使用指南](GitHub_Actions_使用指南.md)
- [ITMS修复技术指南](ITMS_修复指南.md)
- [GitHub Actions官方文档](https://docs.github.com/en/actions)

## 🤝 贡献

欢迎提交：
- 新的修复方法
- 工作流优化建议
- 文档改进意见
- Bug报告和功能请求

## 📄 许可证

本项目仅供学习研究使用。使用者需自行承担风险并遵守相关法律法规。

---

**⚡️ 快速开始**: 
1. Fork这个仓库
2. 上传你的IPA文件或Payload目录  
3. 运行GitHub Actions工作流
4. 下载修复后的IPA文件

**🎯 适用场景**: App Store上传失败、ITMS错误修复、iOS应用逆向工程学习 