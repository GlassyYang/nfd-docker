##### A D节点安装`kite-ndn-cxx`、`kite-ndn-tools`和`kite-NFD`

上传并解压`kite-ndn-cxx.tar.gz`到`/home/pcladmin`，卸载现有版本`ndn-cxx`并安装上传的版本
```shell
#卸载现有的ndn-cxx
cd /home/pcladmin/ndn-cxx
./waf uninstall
#安装上传的版本
cd /home/pcladmin/kite-ndn-cxx
./waf configure
./waf
./waf install
```
上传并解压`kite-ndn-tools`到`/home/pcladmin`，卸载现有版本`kite-ndn-tools`并安装上传的版本
```shell
#进入ndn-tools文件夹
./waf uninstall
#安装上传的版本
cd /home/pcladmin/kite-ndn-tools
./waf configure
./waf
./waf install
```
卸载`NFD`
```shell
#进入NFD文件夹
./waf uninstall
```
安装`kite-NFD`
```shell
#下载kite-NFD仓库
git clone https://github.com/KITE-2018/kite-NFD --recursive
#由于GitHub访问不稳定因此改为上传kite-NFD.tar.gz
#编译安装
cd kite-NFD
./waf configure
./waf
./waf install
````
配置动态链接
```shell
echo /usr/local/lib >> /etc/ld.so.conf
/sbin/ldconfig
```

##### 安全配置
上传并解压安全文件`sec.tar.gz`到`/home/pcladmin/sec`
A节点作为MP，执行下面命令
```shell
#进行MP的安全配置
ndnsec import -i alice.safebag -P 1
cp nfd.conf rv.cert /usr/local/etc/ndn/
```
D节点作为RV，执行下面命令
```shell
ndnsec import -i rv.safebag -P 1
cp rv.conf alice.cert /usr/local/etc/ndn/
cp nfd.conf rv.cert /usr/local/etc/ndn/
```

##### 测试KITE
启动B、C上的有状态转发模块、控制器和POF交换机，启动A、D上的前置头处理模块
A、D执行：

```bash
nfd-start
```
A（MP）上执行：
```bash
nfdc face create udp://127.0.0.1:21987
nfdc route add /rv udp://127.0.0.1:21987
```

启动RV程序，D（RV）上执行：
```bash
nfdc strategy set /rv /localhost/nfd/strategy/multicast
NDN_LOG=kite.*=ALL kiterv /rv
```

启动MP程序，A（MP）上执行：
```bash
NDN_LOG=kite.*=ALL kiteproducer -r /rv -p /alice -l 1000000
```
运行MP窗口下按下 `Ctrl+C`，等待1s
D（Consumer）上执行：
```bash
#要先关闭rv程序
#执行客户端命令
nfdc face create udp://127.0.0.1:21987
nfdc route add /rv udp://127.0.0.1:21987
ndnpeek /rv/alice/photos/selfie.png -v -w 2000
```