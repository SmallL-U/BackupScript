# 备份脚本

[README](README.md) | [中文文档](README_zh.md)

这个项目包含一组shell脚本，可以自动化备份本地和远程源到本地和远程目标的过程。脚本还处理旧备份的清理，并为备份过程提供日志。

## 脚本

项目包含以下脚本：

- `env.sh`：定义配置文件路径。
- `pre.sh`：检查备份是否启用并声明配置变量。
- `run.sh`：处理备份过程，包括Docker中断，归档本地源，下载和归档远程源。
- `after.sh`：处理备份后的任务，如Docker中断，将临时源复制到目标，清理临时文件，从目标清理过期源。
- `utils.sh`：包含从配置文件读取值和日志的实用函数。
- `fire.sh`：主脚本，检查环境，更改工作目录，并按顺序执行其他脚本。

## 配置

备份过程可以通过`backup.properties`文件进行配置。以下是可以设置的属性：

- `enable`：备份过程是否启用。
- `tmp_dir`：备份过程中临时文件的目录。
- `cleanup.min_file`：目标目录中要保留的最小文件数。
- `cleanup.date`：清理日期。早于此日期的文件将被清理。
- `source.local.*`：要备份的本地源。
- `source.remote.*`：要备份的远程源。
- `target.local.*`：备份将存储的本地目标。
- `target.remote.*`：备份将存储的远程目标。
- `interrupt.enable`：是否启用Docker中断。
- `interrupt.keyword.*`：Docker中断的关键字。

## 使用

要使用备份脚本，请按照以下步骤操作：

1. 克隆仓库。
2. 根据您的需要配置`backup.properties`文件。
3. 运行`fire.sh`脚本。

## 日志

备份过程的日志存储在`logs`目录中。每个日志文件都以备份过程的日期命名。超过30天的日志将自动删除。

## 依赖

备份脚本需要以下工具：

- Bash
- pigz
- jq
- rclone

请确保在运行脚本之前安装了这些工具。