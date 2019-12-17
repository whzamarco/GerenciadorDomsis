#!/bin/bash
# Nome: Install_DS.sh
# Descrição: Instala o gerenciador de banco de dados Sybase 16 - 64 bits
# Versões testadas: Debian 7 e 8, CentOS 6 e 7, Ubuntu 12.04 e 14.04, Mint 19 Cinnamon

versao='3.0.0'

versaoSistema(){

dpkg --help > /dev/null 2>&1  # Comando teste

if [ $? -eq 0 ] ; then
	tput setaf 1	
	echo '  ----------------------------------------------------'
        echo ' |       Versões homologadas SQL Anywhere 16          |'
        echo ' |----------------------------------------------------|'
        echo ' | Kernel: 2.6.18 ao 2.6.32; glibc 2.5, 2.9 e 2.12    |'
        echo ' | Kernel: 3.2.0 ao 3.12.28; glibc 2.15, 2.17 e 2.19  |'
        echo '  ----------------------------------------------------'
        echo

	glibc=`ldd --version | grep GLIBC`
	echo "::: Versões instaladas em seu sistema :::"
	echo "glibc - $glibc"
	kernel=`uname -r | cut -c 1-6`
	echo "Kernel - $kernel"
	echo 
	tput sgr0

elif [ glibc=`rpm -q glibc | cut -c 7-10` ] ; then
 	tput setaf 1
	echo '  ----------------------------------------------------'
        echo ' |       Versões homologadas SQL Anywhere 16          |'
        echo ' |----------------------------------------------------|'
        echo ' | Kernel: 2.6.18 ao 2.6.32; glibc 2.5, 2.9 e 2.12    |'
        echo ' | Kernel: 3.2.0 ao 3.12.28; glibc 2.15, 2.17 e 2.19  |'
        echo '  ----------------------------------------------------'
        echo 

	glibc=`rpm -q glibc | cut -c 7-10`
	echo "::: Versões instaladas em seu sistema :::"
	echo "glibc - $glibc"
	kernel=`uname -r | cut -c 1-6`
	echo "Kernel - $kernel"
	tput sgr0
	sleep 3
else 
	tput setaf 7
	echo 'Não foi possivel obter a versão do kernel e da biblioteca glibc'
	tput sgr0
fi

}

Instalacao(){
unset srvnome
unset local_inst
unset dir_back
unset half_memory

if [ -d /opt/sybase/SYBSsa16 ] ; then
	tput setaf 7
	echo 'Gerenciador já instalado!'
	tput sgr0
	sleep 1
        tput setaf 2
        echo 'Pressione [Enter] para voltar ao menu ou CTRL+C para sair...'
        tput sgr0
        read -p ''
	Menu # Função
elif [ -d /opt/ ] ; then
	clear
	mkdir -p /opt/sybase/SYBSsa16
	versaoSistema # Função
	tput setaf 7
	echo 'Iniciando instalação...'
	echo 'Instalando o Gerenciador Sybase...'
	tput sgr0
	sleep 3
	yum install wget -y > /dev/null 2>&1
	yum install psmisc -y > /dev/null 2>&1
	yum install libnsl -y > /dev/null 2>&1
if [ -f /tmp/ASA-1600-2747-Linux-64.tar.gz ] ; then
	tar -xvf /tmp/ASA-1600-2747-Linux-64.tar.gz -C /opt > /dev/null 2>&1
	chmod +x -R /opt/sybase/SYBSsa16 
	touch /opt/sybase/SYBSsa16/instalacao.txt
	rm /opt/sybase/SYBSsa16/bin64/setenv
	echo 'SYBHOME="/opt/sybase/SYBSsa16"' >> /opt/sybase/SYBSsa16/bin64/setenv
	echo 'PATH="$PATH:$SYBHOME/bin64"' >> /opt/sybase/SYBSsa16/bin64/setenv
	echo 'LD_LIBRARY_PATH="$SYBHOME/lib64"' >> /opt/sybase/SYBSsa16/bin64/setenv
	echo 'export PATH LD_LIBRARY_PATH' >> /opt/sybase/SYBSsa16/bin64/setenv	
elif `wget -c -P /opt http://download.dominiosistemas.com.br/instalacao/diversos/sybase16_linux_64/ASA-1600-2747-Linux-64.tar.gz` ; then
	tar -xvf /opt/ASA-1600-2747-Linux-64.tar.gz -C /opt > /dev/null 2>&1
	chmod +x -R /opt/sybase/SYBSsa16
	touch /opt/sybase/SYBSsa16/instalacao.txt
	rm /opt/sybase/SYBSsa16/bin64/setenv
        echo 'SYBHOME="/opt/sybase/SYBSsa16"' >> /opt/sybase/SYBSsa16/bin64/setenv
        echo 'PATH="$PATH:$SYBHOME/bin64"' >> /opt/sybase/SYBSsa16/bin64/setenv
        echo 'LD_LIBRARY_PATH="$SYBHOME/lib64"' >> /opt/sybase/SYBSsa16/bin64/setenv
        echo 'export PATH LD_LIBRARY_PATH' >> /opt/sybase/SYBSsa16/bin64/setenv
	mv /opt/ASA-1600-2747-Linux-64.tar.gz /tmp > /dev/null 2>&1
else
	clear
	tput setaf 7
	echo 'Por favor verifique sua conexão de internet!'
	tput sgr0
	echo
        tput setaf 2
        echo 'Pressione [Enter] para voltar ao menu ou CTRL+C para sair...'
        tput sgr0
        read -p ''
	Menu # Função
	
	fi
else
	mkdir /opt
	Menu # Função
fi
	touch /etc/profile.d/domsis.sh
	chmod +x /etc/profile.d/domsis.sh
	echo '#!/bin/bash' >> /etc/profile.d/domsis.sh
	echo 'source /opt/sybase/SYBSsa16/bin64/setenv > /dev/null 2>&1' >> /etc/profile.d/domsis.sh


while [ ! -f "$local_inst" ]
	do
		tput setaf 1
		echo "Arquivos de banco de dados encontrados:"
		tput sgr0
		contabilFile=$(find / -name *ontabil.db) # pesquisa arquivos de banco de dados no servidor
		for file in $contabilFile; do
			echo $file
		done
		tput setaf 1
		echo 'Informe o arquivo de banco de dados a ser utilizado conforme: [ /Contabil/Dados/Contabil.db ]'
		tput sgr0
		read local_inst
		if [ -f "$local_inst" ] ; then
			echo "$local_inst" >> /opt/sybase/SYBSsa16/instalacao.txt
			chmod +x /opt/sybase/SYBSsa16/bin64/setenv
		else
			tput setaf 1
			echo 'Arquivo não existe! Tente novamente.'
			sleep 3
			tput sgr0
		fi
	done
numero=1
while [ $numero != 0 ]
	do
		tput setaf 1
		echo 3 > /proc/sys/vm/drop_caches 
		sysctl -w vm.drop_caches=3 > /dev/null 2>&1
		echo '-------------------------------------------'
		free -mh | grep -A 1 livre
		free -mh | grep -A 1 free
		echo '-------------------------------------------'
		a=$(grep MemFree /proc/meminfo | awk '{print $2}')
		b=$((($a/100*80)/1024))
		tput setaf 3
		echo "Memória recomendada: ${b} MB"
		tput sgr0
		tput setaf 1
		echo 'Informe a quantidade de memória que será usada pelo banco. Acima é mostrada a quantidade de memória livre no sistema em MB:'
		tput sgr0
		read half_memory
	[ $half_memory -gt 0 ] 2> /dev/null
	if [ $? -eq 0 ] ; then
		numero=0
	else
		tput setaf 7
		echo 'Por favor, informe somente números!'
		tput sgr0
	fi
	done
while [ -z $srvnome ]
	do
		tput setaf 1
		echo 'Informe o nome do servidor. Ex: srvlinux, srvcontabil'
		tput sgr0
		read srvnome
	if [ -z $srvnome ] ; then
		tput setaf 7
		echo 'Por favor informe o nome do servidor!'
		tput sgr0
	fi
	done
source /opt/sybase/SYBSsa16/bin64/setenv

escolhaDistrib # Função

iniciarBanco # Função


}

Validar(){
	# recup_local="`awk 'NR>=0 && NR<=1' /opt/sybase/SYBSsa16/instalacao.txt`" # Recupera local de instalação
	tput setaf 7
	echo 'Não implementado!'
	# echo 'Informe o nome de usuário com permissão para validação:'
	# read usuario
	# echo 'Informe a senha:'
	# read senha
	# dbvalid -c "UID=$usuario;PWD=$senha;DBF=$recup_local/contabil/dados/contabil.db" -fx
	tput sgr0
        echo 
	tput setaf 2
	echo 'Pressione [Enter] para voltar ao menu ou CTRL+C para sair...'
	tput sgr0
	read -p ''
        #read -p 'Pressione [Enter] para voltar ao menu ou CTRL+C para sair...'
	#tput sgr0
        Menu # Função

}

maiusculaMinuscula(){

ls *[A-Z]* | while read maiuscula
do
	minuscula=`echo $maiuscula | tr [A-Z] [a-z]`
	mv $maiuscula $minuscula > /dev/null 2>&1
done

}

escolhaDistrib(){

dist=0
while [ $dist == 0 ] ;
	do	
		#clear
		#Head # Função
		tput setaf 1
		echo 'Qual distribuição está sendo usada? informe o número:'
		echo '1 - Debian/Ubuntu/Mint'
		echo '2 - CentOS/Suse/Fedora'
		tput sgr0
		read dist
	  if [ -z "$dist" ] ; then
		dist=0
		#clear
		#Head # Função
		tput setaf 7
		echo "Por favor informe um valor!"
		sleep 2
		tput sgr0
	elif [ "$dist" -eq 1 ] ; then
		initDistribDEB # Função
	elif [ "$dist" -eq 2 ] ; then
		initDistribRPM # Função
	else
		dist=0
		#clear
		#Head # Função
		tput setaf 7
		echo 'Número inválido tente novamente!'
		sleep 2
		tput sgr0
	fi
	done

}

initDistribDEB() {

touch /etc/init.d/startDomsis.sh
chmod +x /etc/init.d/startDomsis.sh
echo '#!/bin/bash' >> /etc/init.d/startDomsis.sh
echo '### BEGIN INIT INFO' >> /etc/init.d/startDomsis.sh
echo '# Provides: SQL Anywhere' >> /etc/init.d/startDomsis.sh
echo '# Required-Start: $remote_fs $syslog' >> /etc/init.d/startDomsis.sh
echo '# Required-Stop:  $remote_fs $syslog' >> /etc/init.d/startDomsis.sh
echo '# Default-Start:  2 3 4 5' >> /etc/init.d/startDomsis.sh
echo '# Default-Stop:   0 1 6' >> /etc/init.d/startDomsis.sh
echo '# Short-Description: Start daemon at boot time' >> /etc/init.d/startDomsis.sh
echo '# Description: Enable service provided by daemon.' >> /etc/init.d/startDomsis.sh
echo '### END INIT INFO' >> /etc/init.d/startDomsis.sh
echo 'if [ "$(id -u)" != "0" ]; then' >> /etc/init.d/startDomsis.sh
echo 'echo 'Você deve executar este script como root!'' >> /etc/init.d/startDomsis.sh
echo 'else' >> /etc/init.d/startDomsis.sh
echo 'source /opt/sybase/SYBSsa16/bin64/setenv > /dev/null 2>&1' >> /etc/init.d/startDomsis.sh
echo 'echo 'Liberando porta 2638 no firewall'' >> /etc/init.d/startDomsis.sh
echo 'iptables -D INPUT -p tcp --dport 2638 -j ACCEPT > /dev/null 2>&1' >> /etc/init.d/startDomsis.sh
echo 'iptables -I INPUT -p tcp --dport 2638 -j ACCEPT' >> /etc/init.d/startDomsis.sh
echo 'iptables -D INPUT -p udp --dport 2638 -j ACCEPT > /dev/null 2>&1' >> /etc/init.d/startDomsis.sh
echo 'iptables -I INPUT -p udp --dport 2638 -j ACCEPT' >> /etc/init.d/startDomsis.sh
echo 'echo 'Iniciando o servidor...'' >> /etc/init.d/startDomsis.sh
echo 'dbsrv16 -c '$half_memory'M -n '$srvnome' -ud -o /opt/sybase/SYBSsa16/logservidor_'$srvnome'.txt '$local_inst' > /dev/null 2>&1' >> /etc/init.d/startDomsis.sh
echo 'if [ $? -eq 0 ] ; then' >> /etc/init.d/startDomsis.sh
echo 'echo 'Banco de Dados $srvnome iniciado com sucesso!'' >> /etc/init.d/startDomsis.sh
echo 'else' >> /etc/init.d/startDomsis.sh
echo 'echo 'Não foi possivel iniciar o banco de dados!'' >> /etc/init.d/startDomsis.sh
echo 'fi' >> /etc/init.d/startDomsis.sh
echo 'fi' >> /etc/init.d/startDomsis.sh

echo 'Configuração concluida, caso queira pode avaliar o arquivo /etc/init.d/startDomsis.sh'

# Comando para inicialização do sistema
sudo update-rc.d startDomsis.sh defaults > /dev/null 2>&1

if [ $? -eq 127 ] ; then
	#clear
	tput setaf 7
	echo 'A escolha da distribuição não é a correta, tente novamente!'
	tput sgr0
	rm /etc/init.d/startDomsis.sh
	sleep 2
	escolhaDistrib # Função
fi

}

initDistribRPM() {
touch /etc/init.d/startDomsis.sh
chmod +x /etc/init.d/startDomsis.sh
echo '#!/bin/bash' >> /etc/init.d/startDomsis.sh
echo '# chkconfig: 345 99 10' >> /etc/init.d/startDomsis.sh
echo '# description: Domsis' >> /etc/init.d/startDomsis.sh
echo 'if [ "$(id -u)" != "0" ]; then' >> /etc/init.d/startDomsis.sh
echo 'echo 'Você deve executar este script como root!'' >> /etc/init.d/startDomsis.sh
echo 'else' >> /etc/init.d/startDomsis.sh
echo 'source /opt/sybase/SYBSsa16/bin64/setenv > /dev/null 2>&1' >> /etc/init.d/startDomsis.sh
echo 'echo 'Liberando porta 2638 no firewall'' >> /etc/init.d/startDomsis.sh
echo 'firewall-cmd --permanent --zone=public --remove-port=2638/tcp' >> /etc/init.d/startDomsis.sh
echo 'firewall-cmd --permanent --zone=public --remove-port=2638/udp' >> /etc/init.d/startDomsis.sh
echo 'firewall-cmd --permanent --zone=public --add-port=2638/tcp' >> /etc/init.d/startDomsis.sh
echo 'firewall-cmd --permanent --zone=public --add-port=2638/udp' >> /etc/init.d/startDomsis.sh
echo 'systemctl restart firewalld.service' >> /etc/init.d/startDomsis.sh
echo 'echo 'Iniciando o servidor...'' >> /etc/init.d/startDomsis.sh
echo 'dbsrv16 -c '$half_memory'M -n '$srvnome' -ud -o /opt/sybase/SYBSsa16/logservidor.txt '$local_inst' > /dev/null 2>&1' >> /etc/init.d/startDomsis.sh
echo 'if [ $? -eq 0 ] ; then' >> /etc/init.d/startDomsis.sh
echo 'echo 'Banco de Dados $srvnome iniciado com sucesso!'' >> /etc/init.d/startDomsis.sh
echo 'else' >> /etc/init.d/startDomsis.sh
echo 'echo 'Não foi possivel iniciar o banco de dados!'' >> /etc/init.d/startDomsis.sh
echo 'fi' >> /etc/init.d/startDomsis.sh
echo 'fi' >> /etc/init.d/startDomsis.sh

echo 'Configuração concluida, caso queira pode avaliar o arquivo /etc/init.d/startDomsis.sh'

cd /etc/init.d/
chkconfig --add startDomsis.sh > /dev/null 2>&1
chkconfig --level 235 startDomsis.sh on > /dev/null 2>&1

if [ $? -eq 127 ] ; then
	#clear
	tput setaf 7
	echo 'A escolha da distribuição não é a correta, tente novamente!'
	tput sgr0
	rm /etc/init.d/startDomsis.sh
	sleep 2
	escolhaDistrib # Função
fi

}

Desinstalacao(){
confirma="0"
clear
if [ -d "/opt/sybase/SYBSsa16" ] ; then
	tput setaf 1
	echo 'Este processo ira parar o banco de dados, confirma?[s/n]'
	read confirma
	if [ -z "$confirma" ] ; then
		confirma="0"
		tput setaf 7
		echo "Por favor informe um valor!"
		sleep 2
		tput sgr0
	elif [ "$confirma" = "S" -o "$confirma" = "s" ] ; then
		tput setaf 7
		echo 'Parando o banco de dados! Aguarde.'
		sleep 10
		killall -w -s 15 dbsrv16 > /dev/null 2>&1
		echo 'Desinstalando o Gerenciador...'
		sleep 1
		rm -fr /opt/sybase > /dev/null 2>&1
		rm /etc/profile.d/domsis.sh > /dev/null 2>&1
		rm /etc/init.d/startDomsis.sh > /dev/null 2>&1
		echo 'Removendo regras no firewall...'
		sleep 1
		firewall-cmd --permanent --zone=public --remove-port=2638/tcp > /dev/null 2>&1
		firewall-cmd --permanent --zone=public --remove-port=2638/udp > /dev/null 2>&1
		iptables -D INPUT -p tcp --dport 2638 -j ACCEPT > /dev/null 2>&1
        iptables -D INPUT -p udp --dport 2638 -j ACCEPT > /dev/null 2>&1
		echo 'Removendo inicialização automática...'
		sleep 1
		update-rc.d -f startDomsis.sh remove > /dev/null 2>&1
		echo 'Gerenciador desinstalado com sucesso!'
		tput sgr0
	elif [ "$confirma" = "N" -o "$confirma" = "n" ] ; then
		tput setaf 2
        echo 'Pressione [Enter] para voltar ao menu ou CTRL+C para sair...'
        tput sgr0
        read -p ''
		Menu # Função
	else
		confirma="0"
		tput setaf 7
		echo 'Número inválido tente novamente!'
		sleep 2
		tput sgr0
	fi
	echo
	tput setaf 2
	echo 'Pressione [Enter] para voltar ao menu ou CTRL+C para sair...'
	tput sgr0
	read -p ''
	Menu # Função
else
	tput setaf 7
	echo 'Gerenciador não instalado!'
	tput sgr0
	sleep 2
	Menu # Função
fi

}

iniciarBanco(){

if [ -d "/opt/sybase/SYBSsa16" ] ; then
banco=`ps axu | grep dbsrv | grep -v grep`;
op=0
while [ $op == 0 ] ;
	tput setaf 1
	echo 'Deseja iniciar o banco de dados agora?'
	echo '1 - Sim'
	echo '2 - Não'
	tput sgr0
	read op
do
	if [ -z "$op" ] ; then
		op=0
                clear
                tput setaf 7
                echo "Por favor informe um valor!"
                sleep 2
                tput sgr0	
	elif [ "$op" -eq 1 ] ; then
		if [ "$banco" ] ; then
			op=0
			tput setaf 7
			echo 'Banco de Dados já iniciado, favor avaliar!'; novoBanco # Funcão
			tput sgr0
			echo
		        tput setaf 2
		        echo 'Pressione [Enter] para voltar ao menu ou CTRL+C para sair...'
		        tput sgr0
		        read -p ''
			Menu # Função
		else
			/etc/init.d/startDomsis.sh
			tput sgr0
			echo
			novoBanco # Função
		        tput setaf 2
		        echo 'Pressione [Enter] para voltar ao menu ou CTRL+C para sair...'
		        tput sgr0
		        read -p ''
			Menu # Função
		fi
	elif [ "$op" -eq 2 ] ; then
		tput setaf 7
		echo "Banco de dados não iniciado!"
		echo 
		tput sgr0
	        tput setaf 2
	        echo 'Pressione [Enter] para voltar ao menu ou CTRL+C para sair...'
	        tput sgr0
	        read -p ''
		Menu # Função
	else
                tput setaf 7
		op=0
                echo "Opção inválida!"
		sleep 2
                echo 
                tput sgr0
	fi
done	
else
	op=0
	tput setaf 7
    echo 'Gerenciador não instalado!'
    tput sgr0
	sleep 2
	Menu # Função
fi

}

novoBanco() {

### Iniciar outro banco ####

recup_local="`awk 'NR>=0 && NR<=1' /opt/sybase/SYBSsa16/instalacao.txt`"
srvnome="`awk 'NR>=2 && NR<=2' /opt/sybase/SYBSsa16/instalacao.txt`"


tput setaf 1
echo 'Deseja iniciar outro banco?'
echo '1 - Sim'
echo '2 - Não'
tput sgr0
read op
if [ -z "$op" ] ; then
	op=0
	tput setaf 7
	echo "Por favor informe um valor!"
	sleep 2
	tput sgr0
elif [ "$op" -eq 1 ] ; then
	tput setaf 1
	echo "Encontramos esses bancos de dados já iniciados:"
	tput sgr0
	ps -ax | grep dbsrv16 
	tput setaf 1
	echo "Arquivos de banco de dados encontrados:"
	tput sgr0
	contabilFile=$(find / -name *ontabil.db) # pesquisa arquivos de banco de dados no servidor
	for file in $contabilFile; do
		echo $file
	done
	while [ ! -f "$dir_novo_banco" ]  ;
	do
		tput setaf 1
		echo 'Informe o arquivo de banco de dados a ser utilizado conforme: [ /Contabil/Dados/Contabil.db ]'
		tput sgr0
		read dir_novo_banco
		if [ -f "$dir_novo_banco" ] ; then
			echo "$dir_novo_banco" >> /opt/sybase/SYBSsa16/instalacao.txt
			chmod +x /opt/sybase/SYBSsa16/bin64/setenv
		else
			tput setaf 1
			echo 'Arquivo não existe! Tente novamente.'
			sleep 3
			tput sgr0
		fi
	done
	numero=1
	while [ $numero != 0 ]
	do
		tput setaf 1
		echo 3 > /proc/sys/vm/drop_caches 
		sysctl -w vm.drop_caches=3 > /dev/null 2>&1
		echo '-------------------------------------------'
		free -mh | grep -A 1 livre
		free -mh | grep -A 1 free
		echo '-------------------------------------------'
		a=$(grep MemFree /proc/meminfo | awk '{print $2}')
		b=$((($a/100*80)/1024))
		tput setaf 3
		echo "Memória recomendada: ${b} MB"
		tput sgr0
		tput setaf 1
		echo 'Informe a quantidade de memória que será usada pelo banco. Acima é mostrada a quantidade de memória livre no sistema em MB:'
		tput sgr0
		read half_memory
		[ $half_memory -gt 0 ] 2> /dev/null
		if [ $? -eq 0 ] ; then
			numero=0
		else	
			tput setaf 7
			echo 'Por favor, informe somente números!'
			tput sgr0
		fi
	done
	while [ -z $srvnome2 ]
	do
		tput setaf 1
		echo 'Informe o nome do servidor para o novo banco:'
		tput sgr0
		read srvnome2
		if [ -z $srvnome2 ] ; then
			tput setaf 7
			echo 'Nome de servidor vazio, por favor informe o nome do servidor.'
			tput sgr0
		else
			source /opt/sybase/SYBSsa16/bin64/setenv
			tput setaf 7
			echo 'Iniciando banco de dados...'
			tput sgr0
			echo 'dbsrv16 -c '$half_memory'M -n '$srvnome2' -ud -o /opt/sybase/SYBSsa16/logservidor_'$srvnome2'.txt '$dir_novo_banco'' >> /etc/init.d/startDomsis.sh
			dbsrv16 -c "$half_memory"M -n "$srvnome2" -ud -o /opt/sybase/SYBSsa16/logservidor_"$srvnome2".txt "$dir_novo_banco"
			tput setaf 7
			echo "Banco de dados $srvnome2 iniciado com sucesso!"
			tput sgr0
			echo
			tput setaf 2
			echo 'Pressione [Enter] para voltar ao menu ou CTRL+C para sair...'
			tput sgr0
			read -p ''
			Menu # Função
		fi
	done
elif [ "$op" -eq 2 ] ; then
	tput setaf 2
	echo 'Pressione [Enter] para voltar ao menu ou CTRL+C para sair...'
	tput sgr0
	read -p ''
	Menu # Função
else
	tput setaf 7
	echo 'Opção inválida, tente novamente!'
	tput sgr0
fi


}

pararBanco(){
id_processo=0
if [ -d "/opt/sybase/SYBSsa16" ] ; then
	tput setaf 1
	echo "Encontramos esses bancos de dados já iniciados:"
	tput sgr0
	ps -ax | grep dbsrv16 
	tput setaf 1
	echo "Informe o ID do banco de dados a ser parado:"
	tput sgr0
	read id_processo
	tput setaf 7
	echo 'Parando banco de dados! Aguarde.'
	tput sgr0
	sleep 2
	kill -15 $id_processo > /dev/null 2>&1
	if [ $? -eq 0 ] ; then
		tput setaf 7
		echo 'Banco de Dados parado com sucesso!'
		tput sgr0
		echo
		tput setaf 7
		echo 'Pressione [Enter] para voltar ao menu ou CTRL+C para sair...'
		tput sgr0
		read -p ''
		Menu # Função
	else
		tput setaf 7
		echo 'Banco de Dados não estava iniciado!'
		tput sgr0
		echo
		tput setaf 2
		echo 'Pressione [Enter] para voltar ao menu ou CTRL+C para sair...'
		tput sgr0
		read -p ''
		Menu # Função
	fi
else
	tput setaf 7
	echo 'Gerenciador não instalado!'
	tput sgr0
	sleep 2
	Menu # Função
fi

}

realizarBackup(){
if [ -d "/opt/sybase/SYBSsa16" ] ; then
	tput setaf 1
	echo 'Este processo ira parar o banco de dados, confirma?[s/n]'
	tput sgr0
	read confirma
	if [ -z "$confirma" ] ; then
		confirma="0"
		tput setaf 7
		echo "Por favor informe um valor!"
		sleep 2
		tput sgr0
	elif [ "$confirma" = "S" -o "$confirma" = "s" ] ; then
		killall -w -s TERM dbsrv16 > /dev/null 2>&1
		tput setaf 7
		echo 'Parando o banco de dados! Aguarde.'
		sleep 10
		echo "Seu backup será salvo no diretório: $HOME/backup_dominio"
		tput sgr0
		mkdir -p $HOME/backup_dominio/Bancos > /dev/null 2>&1
		while read LINHA
		do
			echo "Efetuando o backup do banco de dados: $LINHA"
			pasta="${LINHA%/Contabil.db}"
			tar -zcf "$HOME/backup_dominio/Bancos/dados_$(date +"%d-%m-%Y_%s").tar.gz" $pasta  > /dev/null 2>&1
		done < /opt/sybase/SYBSsa16/instalacao.txt
		tput setaf 7
		echo 'Backup efetuado com sucesso!'
		tput sgr0
        tput setaf 2
        echo 'Pressione [Enter] para voltar ao menu ou CTRL+C para sair...'
        tput sgr0
        read -p ''
		Menu # Função
	elif [ "$confirma" = "N" -o "$confirma" = "n" ] ; then
		tput setaf 2
        echo 'Pressione [Enter] para voltar ao menu ou CTRL+C para sair...'
        tput sgr0
        read -p ''
		Menu # Função
	else
		confirma="0"
		tput setaf 7
		echo 'Número inválido tente novamente!'
		sleep 2
		tput sgr0
	fi

else
	tput setaf 7
	echo 'Gerenciador não instalado!'
	tput sgr0
	sleep 2
	Menu # Função
fi

}

inserirLicenca(){

if [ -d "/opt/sybase/SYBSsa16" ] ; then
	tput setaf 1
	echo 'Insira a quantide de licença contratada:'
	tput sgr0
	read quantLic
	tput setaf 1
	echo 'Insira o nome reduzido ou apelido da Empresa:'
	tput sgr0
	read apelidoEmpresa
	tput setaf 1
	echo 'Insira a razão social da empresa. Ex: Escritório Contabil ltda'
	tput sgr0
	read razaoSocial

	source /opt/sybase/SYBSsa16/bin64/setenv

	dblic -l perseat -u $quantLic /opt/sybase/SYBSsa16/bin64/dbsrv16.lic "$apelidoEmpresa" "$razaoSocial"
	echo
        tput setaf 2
        echo 'Pressione [Enter] para voltar ao menu ou CTRL+C para sair...'
        tput sgr0
        read -p ''
	Menu # Função
else	
	tput setaf 7
	echo 'Gerenciador não instalado!'
	tput sgr0
	sleep 2
	Menu # Função
fi

}

Ajuda(){

	tput setaf 1
	echo '### AJUDA ###' 
	echo '- Para verificação da versao glibc no Ubuntu, execute o comando: ldd --version.'
	echo '- Para verificação de versao glibc no Centos, execute o comando: rpm -q glibc.'
	echo '- dbsrv16: Este é o nome do programa responsável pela inicialização do servidor de banco.'
	tput sgr0
	echo
	tput setaf 2
	echo 'Pressione [Enter] para voltar ao menu ou CTRL+C para sair...'
	tput sgr0
	read -p ''
	Menu # Função

}

Head() {

tput setaf 1 

head="      #####################################################
      |               Bem-vindo ao instalador             |
      |            SQL Anywhere 16 - Linux 64 bits        |
      |                  Versão $versao                |
      #####################################################\n"

printf "$head"

tput sgr0

}

Menu() {

tput setaf 1

if [ "$(id -u)" != "0" ]; then
	echo 'Você deve executar este script como root!'
else
	clear
	Head # Função
#	echo "########################################################"
#	echo "|                Bem-vindo ao instalador               |"
#	echo "|            SQL Anywhere 16 - Linux 64 bits           |"
#	echo "|                  Versão $versao                   |"
#	echo "########################################################"
	tput setaf 1
	echo 'O que deseja realizar?'
	echo 'Digite:'
	tput sgr0
	tput setaf 2
	echo '1 - Instalar.'
	tput setaf 3
	echo '2 - Desinstalar.'
	tput setaf 2
	echo '3 - Iniciar banco de dados.'
	tput setaf 3
	echo '4 - Parar o Banco de dados.'
	tput setaf 2
	echo '5 - Realizar um backup.'
	tput setaf 3 
	echo '6 - Inserir licença.'
	tput setaf 2
	echo '7 - Ajuda.'
	tput setaf 3
        #echo '8 - Validar banco de dados.'
        #tput setaf 2
	echo '9 - Sair.'
	tput sgr0
	read var

case $var in
	1) Instalacao ;;
	2) Desinstalacao ;;
	3) iniciarBanco ;;
	4) pararBanco ;; 
	5) realizarBackup ;;
	6) inserirLicenca ;;
	7) Ajuda ;;
        #8) Validar ;;
	9) tput setaf 7 ; echo 'Obrigado!'; tput sgr0 ; exit 0 ;;
	*) tput setaf 7; echo 'Opção inválida, tente novamente!'; tput sgr0 ; sleep 2 ; Menu # Função 
	esac
fi

}

## Funcão inicial ###
Menu 
