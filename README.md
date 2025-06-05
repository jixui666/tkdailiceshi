# TikTok 代理抓包工具

[![Build iOS Dylib](https://github.com/jixui666/tkdailiceshi/actions/workflows/build-dylib.yml/badge.svg)](https://github.com/jixui666/tkdailiceshi/actions/workflows/build-dylib.yml)

一个用于TikTok应用的iOS越狱插件，支持代理抓包功能。

## 功能特性

- 🔍 支持网络请求拦截和修改
- 📱 兼容iOS 12.0及以上版本
- 🛠 使用MonkeyDev/Theos框架开发
- 📦 自动构建和打包

## 系统要求

- iOS 12.0+
- 越狱设备
- MobileSubstrate

## 安装方法

### 方法一：通过Releases下载

1. 前往 [Releases页面](https://github.com/jixui666/tkdailiceshi/releases)
2. 下载最新版本的 `BylibKjc.deb` 文件
3. 使用Filza或类似工具安装deb包

### 方法二：手动安装dylib

1. 下载 `1212.dylib` 文件
2. 将文件复制到设备的 `/Library/MobileSubstrate/DynamicLibraries/` 目录
3. 重启SpringBoard

## 编译说明

项目使用GitHub Actions自动编译，每次推送代码都会：

1. 自动编译iOS dylib文件
2. 创建Cydia安装包
3. 生成Release版本

### 本地编译

如果需要本地编译，请确保安装了：

- Xcode
- MonkeyDev
- Theos

```bash
# 克隆项目
git clone https://github.com/jixui666/tkdailiceshi.git
cd tkdailiceshi

# 编译项目
xcodebuild -project 654323.xcodeproj -scheme 1212 -configuration Release
```

## 项目结构

```
├── 654323.xcodeproj/          # Xcode项目文件
├── BylibKjc/                  # 主要源码目录
│   ├── Package/               # 打包配置
│   │   ├── DEBIAN/           # Debian包控制文件
│   │   └── Library/          # 安装目录结构
│   └── 1212-Prefix.pch      # 预编译头文件
├── 模拟返回/                   # 源码文件
│   ├── wyURLProtocol.h
│   └── wyURLProtocol.m
└── .github/                   # GitHub Actions配置
    └── workflows/
        └── build-dylib.yml
```

## 开发说明

### 主要文件说明

- `wyURLProtocol.h/m`: 核心URL拦截协议实现
- `Info.plist`: 应用配置信息，已修复iOS版本兼容性
- `DEBIAN/control`: Debian包管理配置

### 版本兼容性

项目已解决ITMS-90208错误，所有配置文件中的iOS版本设置已统一：

- `MinimumOSVersion`: 12.0
- `IPHONEOS_DEPLOYMENT_TARGET`: 12.0

## 注意事项

⚠️ **免责声明**：本工具仅供学习和研究使用，请遵守相关法律法规，不要用于非法目的。

## 许可证

本项目仅供学习交流使用。

## 贡献

欢迎提交Issue和Pull Request来改进项目。

## 更新日志

- **v1.0**: 初始版本，支持基础代理抓包功能
- **v1.1**: 修复iOS版本兼容性问题
- **v1.2**: 添加GitHub Actions自动构建 