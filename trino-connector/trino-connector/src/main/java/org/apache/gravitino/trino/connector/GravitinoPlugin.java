/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
package org.apache.gravitino.trino.connector;

import com.google.common.collect.ImmutableList;
import io.trino.spi.Plugin;
import io.trino.spi.connector.ConnectorFactory;

/*[業務邏輯] Trino 插件的入口點，使用 Java SPI (Service Provider Interface) 機制實現
* GravitinoConnectorFactory：負責創建連接器，是連接器的主要工廠類
* Trino 使用這個工廠創建連接器 
* 主要組件：
  GravitinoPlugin：插件入口點
  GravitinoConnectorFactory：連接器工廠
  GravitinoConnector：實際的連接器實現：Trino 和 Gravitino 之間操作的主要入口點
  CatalogConnectorAdapter：不同數據源的適配器
*/

/** Trino plugin endpoint, using java spi mechanism */
public class GravitinoPlugin implements Plugin {

  @Override
  public Iterable<ConnectorFactory> getConnectorFactories() {
    return ImmutableList.of(new GravitinoConnectorFactory());
  }
}
