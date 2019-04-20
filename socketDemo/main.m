//
//  main.m
//  socketDemo
//
//  Created by nenhall on 2019/4/20.
//  Copyright © 2019 nenhall. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <arpa/inet.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        
        /**
         客户端的文件句柄，如果为-1表示错误

         param AF_INET 表示ipv4
         param SOCK_STREAM 支持tcp协议
         param 0 一般为0
         return 返回一个客户端的描述句柄
         */
        int clientSocketFD = socket(AF_INET, SOCK_STREAM, 0);
        
        if (clientSocketFD ==  -1) {
            perror("create socket error");
            exit(EXIT_FAILURE);
        }
        
        //创建socket的外部地址 node
        struct sockaddr_in servAdd;
        memset(&servAdd, 0, sizeof(servAdd));
        servAdd.sin_family = AF_INET;//ipv4协议
        servAdd.sin_port = htons(80);//端口
        servAdd.sin_addr.s_addr = inet_addr("183.232.231.174");//地址
        /** 可在终端通过如下命令得到对应域名的地址
         ➜  ~  nslookup www.baidu.com
         Server:        172.20.10.1
         Address:    172.20.10.1#53
         
         Non-authoritative answer:
         www.baidu.com    canonical name = www.a.shifen.com.
         Name:    www.a.shifen.com
         Address: 183.232.231.174
         Name:    www.a.shifen.com
         Address: 183.232.231.172
         */
        
        // 设置两个变量缓冲区来接受或者发送相关内容
        char sndBuf[1024];
        char rcvBuf[2048];
        
        
        //创建一个“插头”变量，来判定是否 收 发 成功
        ssize_t ret;
        
        //建立tcp连接
        if ((connect(clientSocketFD, (const struct sockaddr *)&servAdd, sizeof(servAdd))) == -1) {
            perror("connect error");
            exit(EXIT_FAILURE);
        }
        
        memset(sndBuf, 0, 1024);
        memset(rcvBuf, 0, 2048);
        
        // 参照：https://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol
        strcat(sndBuf, "GET ");// 后面需要有空格，标准格式，参考上面网站
        strcat(sndBuf, "https://www.baidu.com");
        strcat(sndBuf, " HTTP/1.1\r\n");// 前面需要有空格，标准格式，参考上面网站
        strcat(sndBuf, "Host: ");// 后面需要有空格，标准格式，参考上面网站
        strcat(sndBuf, "baidu.com");
        strcat(sndBuf, "\r\n");
        strcat(sndBuf, "connection: keep-alive\r\n");
        strcat(sndBuf, "\r\n");//这个必须有，是头部信息的一种标准格式
        
        puts(sndBuf);
        
        
        // 将http 头部信息发送给服务器
        if ((ret = send(clientSocketFD, sndBuf, 1024, 0)) == -1) {
            perror("send error");
            exit(EXIT_FAILURE);
        } else {
            puts("send success");
            
        }
        
        do {
            if ((ret = recv(clientSocketFD, rcvBuf, 2048, 0)) == -1) {
                perror("rece error");
                system("pause");
                exit(EXIT_FAILURE);
            } else {
                printf("rcvBuf：\n%s",rcvBuf);
                memset(rcvBuf, 0, 2048);
            }
            
        } while (ret > 0);
        
        close(clientSocketFD);
        
        
        
    }
    return 0;
}
