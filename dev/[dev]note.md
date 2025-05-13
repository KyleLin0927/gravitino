dev 目錄主要是用於專案的開發、測試、打包和發布相關的工具和腳本。

1. **dev/docker**：
    - 用於開發和測試環境的 Docker 配置
    - 包含各種元件的 Docker 映像構建腳本
    - 主要用於開發和測試階段
2. **dev/release**：
    - 包含發布相關的腳本和工具
    - release-build.sh：用於構建發布版本
    - release-tag.sh：用於標記發布版本
    - check-license.sh：檢查開源許可證
    - do-release.sh：執行發布流程
3. **dev/ci**：
    - 持續整合（CI）相關的配置和腳本
    - check_commands.sh：檢查命令可用性
    - lintconf.yaml：代碼風格檢查配置
    - chart_schema.yaml：圖表模式定義
4. **dev/charts**：
    - 用於 Kubernetes 部署的 Helm charts
    - 包含部署配置和模板




雖然它們都是 Gravitino 的 Docker 映像，但它們的用途和目標環境是不同的。公開映像是經過完整測試和驗證的生產版本，而 dev/docker/gravitino 中的配置主要用於開發和測試目的。

dev/docker/gravitino 目錄和公開的 Docker 映像確實是相關的，它們的關係如下：
