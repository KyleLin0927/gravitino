#!/usr/bin/env bash
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

# Python 的 os 模組提供了存取這些環境變數的介面
import os

# [系統邏輯] 這個腳本用於更新 Iceberg REST Server 的配置文件。
# 這個腳本在 Docker 容器啟動時執行，用於根據環境變數動態生成 Iceberg REST Server 的配置文件。
# 它會將環境變量中的值更新到配置文件中。

# 這個腳本會將環境變量中的值更新到配置文件中。
env_map = {
  "GRAVITINO_IO_IMPL" : "io-impl",
  "GRAVITINO_URI" : "uri",
  "GRAVITINO_CATALOG_BACKEND" : "catalog-backend",
  "GRAVITINO_JDBC_DRIVER": "jdbc-driver",
  "GRAVITINO_JDBC_USER": "jdbc-user",
  "GRAVITINO_JDBC_PASSWORD": "jdbc-password",
  "GRAVITINO_WAREHOUSE" : "warehouse",
  "GRAVITINO_CREDENTIAL_PROVIDER_TYPE" : "credential-providers",
  "GRAVITINO_CREDENTIAL_PROVIDERS" : "credential-providers",
  "GRAVITINO_GCS_CREDENTIAL_FILE_PATH" : "gcs-service-account-file",
  "GRAVITINO_GCS_SERVICE_ACCOUNT_FILE" : "gcs-service-account-file",
  "GRAVITINO_S3_ACCESS_KEY" : "s3-access-key-id",
  "GRAVITINO_S3_SECRET_KEY" : "s3-secret-access-key",
  "GRAVITINO_S3_ENDPOINT" : "s3-endpoint",
  "GRAVITINO_S3_REGION" : "s3-region",
  "GRAVITINO_S3_ROLE_ARN" : "s3-role-arn",
  "GRAVITINO_S3_EXTERNAL_ID" : "s3-external-id",
  "GRAVITINO_AZURE_STORAGE_ACCOUNT_NAME" : "azure-storage-account-name",
  "GRAVITINO_AZURE_STORAGE_ACCOUNT_KEY" : "azure-storage-account-key",
  "GRAVITINO_AZURE_TENANT_ID" : "azure-tenant-id",
  "GRAVITINO_AZURE_CLIENT_ID" : "azure-client-id",
  "GRAVITINO_AZURE_CLIENT_SECRET" : "azure-client-secret",
  "GRAVITINO_OSS_ACCESS_KEY": "oss-access-key-id",
  "GRAVITINO_OSS_SECRET_KEY": "oss-secret-access-key",
  "GRAVITINO_OSS_ENDPOINT": "oss-endpoint",
  "GRAVITINO_OSS_REGION": "oss-region",
  "GRAVITINO_OSS_ROLE_ARN": "oss-role-arn",
  "GRAVITINO_OSS_EXTERNAL_ID": "oss-external-id",

}

# 這個變量用於初始化配置文件。
init_config = {
  "catalog-backend" : "jdbc",
  "jdbc-driver" : "org.sqlite.JDBC",
  "uri" : "jdbc:sqlite::memory:",
  "jdbc-user" : "iceberg",
  "jdbc-password" : "iceberg",
  "jdbc-initialize" : "true",
  "jdbc.schema-version" : "V1"
}

# 這個函數用於解析配置文件。
def parse_config_file(file_path):  
    config_map = {}  
    with open(file_path, 'r') as file:  
        for line in file:  
            stripped_line = line.strip()  
            if stripped_line and not stripped_line.startswith('#'):  
                key, value = stripped_line.split('=', 1)
                key = key.strip()  
                value = value.strip()  
                config_map[key] = value  
    return config_map  

# 這個變量用於更新配置文件。
config_prefix = "gravitino.iceberg-rest."

# 這個函數用於更新配置文件。
def update_config(config, key, value):
    config[config_prefix + key] = value

# 這個變量用於更新配置文件。
config_file_path = 'conf/gravitino-iceberg-rest-server.conf'
config_map = parse_config_file(config_file_path)

# 這部分的主要邏輯是：
# 1. 讀取現有配置文件
# 2. 應用預設配置
# 3. 從環境變數中讀取配置並更新
# 4. 刪除舊的配置文件
# 5. 寫入新的配置文件

for k, v in init_config.items():
    update_config(config_map, k, v)

# # os.environ 是一個字典，包含了所有環境變數
# 當我們使用 os.environ[k] 時，就是在讀取名為 k 的環境變數的值
for k, v in env_map.items():
    if k in os.environ: 
        update_config(config_map, v, os.environ[k])
  
if os.path.exists(config_file_path):  
    os.remove(config_file_path)  

with open(config_file_path, 'w') as file:  
    for key, value in config_map.items():  
        line = "{} = {}\n".format(key, value)  
        file.write(line)  
