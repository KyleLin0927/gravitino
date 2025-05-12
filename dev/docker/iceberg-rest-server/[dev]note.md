**正確的執行順序**：

1. **建置階段**：
    - 首先執行 iceberg-rest-server-dependency.sh 腳本
    - 這個腳本會：
    - 編譯 Iceberg REST Server
    - 下載必要的依賴項
    - 準備所有需要的檔案
    - 將檔案放在 packages/gravitino-iceberg-rest-server 目錄下
2. **Docker 映像建置階段**：
    - 使用 Dockerfile 建立 Docker 映像
    - 這個階段會：
    - 使用 OpenJDK 17 作為基礎映像
    - 將 packages/gravitino-iceberg-rest-server 目錄複製到容器中
    - 設定工作目錄和啟動腳本
3. **容器運行階段**：
    - 當容器啟動時，執行 start-iceberg-rest-server.sh
    - 這個腳本會：
    - 設定執行環境
    - 執行 rewrite_config.py 來生成配置文件
    - 啟動 Iceberg REST Server 服務