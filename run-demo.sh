#!/bin/bash
docker rmi $(docker images | grep "^<none" | awk '{print $3}')
rm -rf hello-jsug
. demo-magic.sh
DEMO_PROMPT="(\w): "
clear

TYPE_SPEED=1000


############

printf "\033[32m⭐️ Spring Boot Projectの雛形を作成します \033[0m\n"
pe "curl https://start.spring.io/starter.tgz \\
  -d javaVersion=11 \\
  -d artifactId=hello-jsug  \\
  -d baseDir=hello-jsug \\
  -d dependencies=web,actuator  \\
  -d packageName=com.example  \\
  -d applicationName=HelloJsugApplication | tar -xzvf -"

############

printf "\033[32m⭐️ ディレクトリを変更します \033[0m\n"
pe "cd hello-jsug"

############

printf "\033[32m⭐️ ソースコードを修正します \033[0m\n"
pe "cat <<'EOF' > src/main/java/com/example/HelloJsugApplication.java
package com.example;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
@RestController
public class HelloJsugApplication {

        @GetMapping(\"/\") 
        public String hello() {
                return \"Hello JSUG!\";
        }

        public static void main(String[] args) {
                SpringApplication.run(HelloJsugApplication.class, args);
        }
}
EOF"

############

TYPE_SPEED=50
printf "\033[32m⭐️ Pack CLIでコンテナイメージをBuildします \033[0m\n"
pe "pack build making/hello-jsug --builder cloudfoundry/cnb:bionic --no-pull -v"

############

printf "\033[32m⭐️ Dockerイメージを確認します \033[0m\n"

pe "docker images"

############

printf "\033[32m⭐️ Dockerイメージを実行します \033[0m\n"
pe "docker run --rm  \\
   -p 8080:8080 \\
   -e MANAGEMENT_ENDPOINTS_WEB_EXPOSURE_INCLUDE='*' \\
  making/hello-jsug"

############

printf "\033[32m⭐️ ソースコードを更新します \033[0m\n"
pe "sed -i '' -e 's/JSUG/JSUG 🍃/g' src/main/java/com/example/HelloJsugApplication.java"

############

printf "\033[32m⭐️ バナーを追加します \033[0m\n"
pe "cp ../banner.txt src/main/resources/"

############

printf "\033[32m⭐️ Pack CLIでコンテナイメージをBuildします \033[0m\n"
pe "pack build making/hello-jsug --builder cloudfoundry/cnb:bionic --no-pull -v"

############

printf "\033[32m⭐️ Dockerイメージを確認します \033[0m\n"

pe "docker images"

############

printf "\033[32m⭐️ Dockerイメージを実行します \033[0m\n"
pe "docker run --rm  \\
    -p 8080:8080  \\
    -e SPRING_OUTPUT_ANSI_ENABLED=ALWAYS  \\
    making/hello-jsug"
