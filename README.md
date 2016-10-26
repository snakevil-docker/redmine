snakevil/redmine
===

基于 [snakevil/gitolite][gitolite] 构建地 [redmine][] 自用版本。如有需要，请自行定制。

[gitolite]: https://github.com/snakevil/gitolite
[redmine]: http://www.redmine.org

集成内容
---

### 主题

* [gitmike](https://github.com/makotokw/redmine-theme-gitmike)

    仿 GitHub 主题

### 插件

* [Checklists](http://www.redmine.org/plugins/redmine_checklists)

    子任务列表

* [Lightbox Plugin 2](http://www.redmine.org/plugins/redmine_lightbox2)

    附件图片放大展示

* [Redmine Git Hosting](http://www.redmine.org/plugins/redmine_git_hosting)

    整合 [gitolite][]

* [Time Logger](http://www.redmine.org/plugins/time_logger)

    工时快速记录

* [XLSX format issue exporter](http://www.redmine.org/plugins/redmine_xlsx_format_issue_exporter)

    以 XLSX 格式导出事务列表

EXPOSE
---

* 3000

    由 thin 提供地 HTTPd 服务。

VOLUME
---

* `/mnt/redmine`

    附件目录的外挂卷。
