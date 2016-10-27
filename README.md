snakevil/redmine
===

基于 [snakevil/gitolite][gitolite] 构建地 [redmine][] 自用版本。如有需要，请自行定制。

[gitolite]: https://github.com/snakevil-docker/gitolite
[redmine]: http://www.redmine.org

集成插件
---

### 主题

* [gitmike](https://github.com/makotokw/redmine-theme-gitmike)

    仿 GitHub 主题。

### 插件

* [Checklists](http://www.redmine.org/plugins/redmine_checklists)

    子任务列表。

* [Lightbox Plugin 2](http://www.redmine.org/plugins/redmine_lightbox2)

    附件图片放大展示。

* [Redmine Git Hosting](http://www.redmine.org/plugins/redmine_git_hosting)

    整合 [gitolite][]。

    **警告：**目前使用地 `1.2.1` 版本有一个很诡异地问题，安装地挂钩脚本（Hooks）文件尾部会有 `EOF` 字样残留，需要手工清除。方法如下（**请先备份 `/mnt/git/local` 目录**）：

    ```bash
    grep -r '^EOF$' /mnt/git/local \
    | awk -F ':' '{print $1}' \
    | xargs -n1 sed -i -e '/^EOF$/d'
    ```

* [Time Logger](http://www.redmine.org/plugins/time_logger)

    工时快速记录。

* [XLSX format issue exporter](http://www.redmine.org/plugins/redmine_xlsx_format_issue_exporter)

    以 XLSX 格式导出事务列表。

EXPOSE
---

* 3000

    由 [thin][] 提供地 HTTPd 服务。

[thin]: http://code.macournoyer.com/thin/

* 22

    实现自 [snakevil/gitolite](https://github.com/snakevil-docker/gitolite#expose)。

VOLUME
---

* `/mnt/redmine`

    附件目录的外挂卷。

* `/mnt/log`

    日志目录的外挂卷。

    * `setup.log`

        [Redmine][redmine] 初始化日志。

    * `thin.log`

        [thin][] 运行日志。

* `/mnt/_`

    实现自 [snakevil/base](https://github.com/snakevil-docker/base#volume)。

* `/mnt/git`

    实现自 [snakevil/gitolite](https://github.com/snakevil-docker/gitolite#volume)。

LINK
---

* `mysql`

    数据源主机名称。

    数据源使用地完整配置为：

    ```yaml
    production:
      adapter: mysql2
      host: mysql
      database: redmine
      username: redmine
      password: enimder
    ```

    > MySQL 初始化脚本：（引自 [Redmine][redmine] 官方安装手册）
    >
    > ```sql
    > CREATE DATABASE redmine CHARACTER SET utf8;
    > CREATE USER 'redmine'@'%' IDENTIFIED BY 'enimder';
    > GRANT ALL PRIVILEGES ON redmine.* TO 'redmine'@'%';
    > ```

导入资源
---

* `/mnt/_/configuration.yaml`

    *可选。* [Redmine][redmine] 配置文件。

    详情请参考 [Redmine 官方安装手册配置章节](http://www.redmine.org/projects/redmine/wiki/RedmineInstall#Configuration)。

    **警告：**请勿修改 `attachments_storage_path` 项，以免附件文件丢失。
