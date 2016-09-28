基于 [snakevil/gitolite][gitolite] 制作的 [redmine][] 自用版本。如有需要，请从[版本库](https://github.com/snakevil-docker/redmine)（`https://github.com/snakevil-docker/redmine`）自行定制。

[gitolite]: https://dev.aliyun.com/detail.html?repoId=13626
[redmine]: http://www.redmine.org/

插件列表
---

### 主题

* [gitmike](https://github.com/makotokw/redmine-theme-gitmike) - 仿 GitHub 主题

### 插件

* [Checklists](http://www.redmine.org/plugins/redmine_checklists) - 子任务列表
* [Lightbox Plugin 2](http://www.redmine.org/plugins/redmine_lightbox2) - 附件图片放大展示
* [Redmine Git Hosting](http://www.redmine.org/plugins/redmine_git_hosting) - 整合 [gitolite][]
* [Time Logger](http://www.redmine.org/plugins/time_logger) - 工时快速记录
* [XLSX format issue exporter](http://www.redmine.org/plugins/redmine_xlsx_format_issue_exporter) - 以 XLSX 格式导出事务列表
* [Redmine Issue Favicon](http://www.redmine.org/plugins/redmine_issue_favicon) - 在站点图标上显示当前手头提案数量
* [Redmine Issue Badge](http://www.redmine.org/plugins/redmine_issue_badge) - 在登录帐号旁显示当前手头提案数量

运行参数
---

### EXPOSE

* `22` - 基于 [gitolite][] 的 SSHD 服务
* `3000` - 依托 thin 的 [redmine][] 程序的 HTTPD 服务

### VOLUME

* `/var/git` - [gitolite][] 的版本库仓库卷
* `/var/lib/redmine` - [redmine][] 的附件文件仓库卷

### ENTRYPOINT [`/srv/up`](https://github.com/snakevil-docker/redmine/blob/master/src/srv/up)

### --link `<container>:mysql`

要正常地运行本镜像实例，需要在创建时关联到外部的数据库镜像实例，默认只支持 mysql 。*如需要使用其它类型的数据库，请自行定制。*

配置文件
---

### 1. [redmine][] 数据库配置文件

**必要。**`/var/lib/redmine` 的本地卷文件夹中的 `database.yml` 会被引入镜像实例中，用于满足数据库的访问需求。其格式为：

```
production:
  adapter: mysql2
  host: mysql
  database: <DB_NAME>
  username: <DB_USER>
  password: <DB_PSWD>
```

### 2. [redmine][] 标准配置文件

**可选。**`/var/lib/redmine` 的本地卷文件夹中的 `configuration.yml` 会被引入镜像实例中，用于满足发送邮件、附件缩略图裁剪等其它需求。其具体配置方式请参考[官方指南](http://www.redmine.org/projects/redmine/wiki/EmailConfiguration)（`http://www.redmine.org/projects/redmine/wiki/EmailConfiguration`）。

### 3. [redmine][] 用 SSH 证书

**可选。**`/var/lib/redmine` 的本地卷文件夹中的 `redmine_gitolite_admin_id_rsa` 和 `redmine_gitolite_admin_id_rsa.pub` 会被引入镜像实例中，用于管理 [gitolite][] 版本库权限。

如不存在，那么在镜像实例启动后，实例自动产生的同名文件会被备份回 `/var/lib/redmine` 的本地卷文件夹中，以确保实例销毁不会影响到已有数据的再使用。

常见问题
---

### 1. 如何使用已有的 [gitolite][] 版本仓库？

1. 将既有的 `repositories` 文件夹复制到 `/var/git` 的本地卷文件夹中；
2. 删除其中的 `gitolite-admin.git` 文件夹；
3. 创建镜像实例；
4. 进入 [redmine][] -「Admin」-「Redmine Git Hosting」-「Rescue」，全部勾选 `Resync all projects ?`、`Resync all SSH keys ?` 和 `Flush Git Cache?`，然后应用。

### 2. 如何往镜像中添加更多的 [redmine][] 插件？

1. 拉取版本库；
2. 创建临时目录 `redmine/plugins`；
3. 解压下载的插件压缩包至临时目录，并正确改名（如：插件要求目录名称为 `foo`，那么正确的目录结构就是 `redmine/plugins/foo`）；
4. 对临时目录 `redmine` 打包成任意 Docker 能够正确识别的压缩格式（如：`.tar.gz`、`.tar.xz` 等）；
5. 将新的压缩包存入版本库内 `include/plugins` 文件夹中；
6. 重新生成镜像。

### 3. 如何往镜像中添加更多的 [redmine][] 主题？

1. 拉取版本库；
2. 创建临时目录 `redmine/public/themes`；
3. 解压下载的主题压缩包至临时目录，并正确改名（如：主题要求目录名称为 `foo`，那么正确的目录结构就是 `redmine/public/themes/foo`）；
4. 对临时目录 `redmine` 打包成任意 Docker 能够正确识别的压缩格式（如：`.tar.gz`、`.tar.xz` 等）；
5. 将新的压缩包存入版本库内 `include/themes` 文件夹中；
6. 重新生成镜像。

### 4. 如何使用其它类型的数据库？

1. 拉取版本库；
2. 修改 `Dockerfile` 中 `echo "  adapter: mysql2" >> config/database.yml && \`  一行，将 `mysql2` 替换为相应的配置值；
3. 重新生成镜像。
