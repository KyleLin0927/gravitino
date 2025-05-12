1. **建置階段：**執行 gravitino-dependency.sh 腳本，這個腳本會：
    - 設定工作目錄和環境變數
    - 清理之前的建置成果
    - 執行兩個 Gradle 任務：
        
        ./gradlew clean build -x test
        
        ./gradlew compileDistribution -x test
        
    - 準備套件目錄：
        
        rm -rf "${gravitino_dir}/packages"
        
        mkdir -p "${gravitino_dir}/packages"
        
    - 複製必要的檔案：
    - 將編譯好的套件複製到 packages/gravitino 目錄
    - 複製各種雲端服務的 bundle jar 檔案到 catalogs/hadoop/libs 目錄
2. **Docker 映像建置階段**：使用 Dockerfile 建立 Docker 映像：
    - 使用 OpenJDK 17 作為基礎映像
    - 設定工作目錄為 /root/gravitino
    - 將建置好的套件複製到容器中
    - 暴露兩個端口：
    - 8090：Gravitino 服務端口
    - 9001：Iceberg REST Server 端口
    - 設定啟動命令為 gravitino.sh start
3. **容器運行階段**：當容器啟動時：
    - 執行 gravitino.sh start 命令
    - 啟動 Gravitino 服務
    - 保持容器運行（通過 tail -f /dev/null 命令）