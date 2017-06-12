#!/bin/bash


###  #####################################################  ###
###   Captura o IP da conexão e registra quando ele mudar   ###
###  Por Luiz peterli (suporte@opentech.etc.br) em 11/06/17 ###
###  #####################################################  ###


###  ###############################################################  ###
###  Esse Script utilza as aplicações curl e sendmail para funcionar  ###
###  ################################################################ ###


####===---|{ DATA E HORA DE INICIO DO PROCEDIMENTO
DTI=`(date --date "now" +%A_%d_de_%B_às_%H:%M:%S_hrs)`

####===---|{ UPTIME DO SERVIDOR
UPM=`uptime | cut -d " " -f3,4,5,6,7|sed 's/,//'|sed 's/,//'`

####===---|{ ARMAZENANDO O NOME DA MAQUINA EM UMA VARIAVEL
NDM=`/bin/hostname`


####===---|{ SERVIÇO DO PPPTD ESTÀ RODANDO?
SPT=`service pptpd status |grep "active" |cut -d " " -f5,6`


####===---|{ CRIANDO ARQUIVO DE ARMAZENAMENTO
if [ ! /tmp/vip.txt ];  then

touch /tmp/vip.txt

fi



####===---|{ LENDO O IP PUBLICO ARMAZENADO NO ARQUIVO E ARMAZENANDO ELE UM UMA VARIAVEL
CIP=`cat /tmp/vip.txt`



####===---|{ ARMAZENANDO AS INFORMACOES DE IP EM UM ARQUIVO PARA ANALISE
curl ipinfo.io >> /tmp/vip.txt



####===---|{ CAPTURA AS NOVAS INFORMACOES DE IP PUBLICO
IPP=`cat /tmp/vip.txt |grep "ip"|awk '{print $2}'|sed 's@[!~"]@@g'|sed 's/,//'`



####===---|{ CAPTURA DAS INFORMACOES DA OPERADORA DE INTERNET
OPR=`cat /tmp/vip.txt |grep "org"|sed 's@[org~]@@g'|sed 's@["~]@@g'|sed 's@[:~]@@g'|sed "1s/^ //"|sed "1s/^ //"|sed "1s/^ //"`


####===---|{ STATUS DAS PORTAS DE CONEXÂO DA VPN
PCV=`iptables -nvL |grep 1194 |awk '{print $3}'`


####===---|{ ARMAZENAR A NOVA INFORMACAO DO IP PUBLICO EM UM ARQUIVO
echo $IPP > /tmp/vip.txt



####===---|{ CRIANDO O ARQUIVO TEMPORARIO PARA O ARMAZENAMENTO DA MENSAGEM DE EMAIL
rm -f /tmp/ede.html; touch /tmp/ede.html



###################====================------------ CODIGO HTML ------------====================###################


echo "<html>" >> /tmp/ede.html
echo "<head>" >> /tmp/ede.html
echo "<meta http-equiv='Content-Type' content='text/html;charset=utf-8'/>" >> /tmp/ede.html
echo "<title> Monitoramente de Mudança de IP Público </title>" >> /tmp/ede.html
echo "</head>" >> /tmp/ede.html
echo "                        <br><hr>" >> /tmp/ede.html
echo "<body>" >> /tmp/ede.html
echo "<table>" >> /tmp/ede.html
echo "<body>" >> /tmp/ede.html
echo "<table>" >> /tmp/ede.html
echo "<tr><td><img title='Relatorio elaborado por Luiz Peterli -- jnr.lzcarlos@gmail.com' img width="60px" height="60px" src='http://i65.tinypic.com/2r5t36r.jpg'/></td>  <td><b><font size='6'>  Relatório de Detecção de Mudança de IP </font size></b></td></tr>" >> /tmp/ede.html
echo "</table>" >> /tmp/ede.html
echo "                             <br><hr>" >> /tmp/ede.html
echo "</br>" >> /tmp/ede.html
echo "</br>" >> /tmp/ede.html
echo "<big><b> Informações de Conexão que acabou de mudar!</b></big>" >> /tmp/ede.html
echo "</br>" >> /tmp/ede.html
echo "</br>" >> /tmp/ede.html
echo "<table border=1>" >> /tmp/ede.html
echo "<tr><td bgcolor='WhiteSmoke' ALIGN=MIDDLE WIDTH=250><b><div align='left'> Nome do Servidor </div></b></td>  <td ALIGN=MIDDLE WIDTH=200><font color='#1E90FF'> $NDM </font></td>" >> /tmp/ede.html
echo "<tr><td bgcolor='WhiteSmoke' ALIGN=MIDDLE WIDTH=250><b><div align='left'> IP Público Antigo </div></b></td>  <td ALIGN=MIDDLE WIDTH=200><font color='#FF0000'> $CIP </font></td>" >> /tmp/ede.html
echo "<tr><td bgcolor='WhiteSmoke' ALIGN=MIDDLE WIDTH=250><b><div align='left'> Novo IP Público </div></b></td>  <td ALIGN=MIDDLE WIDTH=200><font color='#00CED1'> $IPP </font></td>" >> /tmp/ede.html
echo "<tr><td bgcolor='WhiteSmoke' ALIGN=MIDDLE WIDTH=250><b><div align='left'> Operadora de internet </div></b></td>  <td ALIGN=MIDDLE WIDTH=200><font color='#32CD32'> $OPR </font></td>" >> /tmp/ede.html
echo "<tr><td bgcolor='WhiteSmoke' ALIGN=MIDDLE WIDTH=250><b><div align='left'> Data e hora da mudança </div></b></td>  <td ALIGN=MIDDLE WIDTH=200><font color='#2E8B57'> $DTI </font></td>" >> /tmp/ede.html
echo "<tr><td bgcolor='WhiteSmoke' ALIGN=MIDDLE WIDTH=250><b><div align='left'> Tempo de Servidor ligado </div></b></td>  <td ALIGN=MIDDLE WIDTH=200><font color='#9370DB'> $UPM </font></td>" >> /tmp/ede.html
echo "<tr><td bgcolor='WhiteSmoke' ALIGN=MIDDLE WIDTH=250><b><div align='left'> Status da VPN no Servidor </div></b></td>  <td ALIGN=MIDDLE WIDTH=200><font color='#27408B'> $SPT </font></td>" >> /tmp/ede.html
echo "<tr><td bgcolor='WhiteSmoke' ALIGN=MIDDLE WIDTH=250><b><div align='left'> Status das portas da VPN </div></b></td>  <td ALIGN=MIDDLE WIDTH=200><font color='#6959CD'> $PCV </font></td>" >> /tmp/ede.html
echo "</table>" >> /tmp/ede.html
echo "</br>" >> /tmp/ede.html
echo "</br>" >> /tmp/ede.html
echo "</br>" >> /tmp/ede.html
echo "                             <br><hr>" >> /tmp/ede.html
echo "<big><b> Informativo de mudança do número de IP Público </b></big>" >> /tmp/ede.html
echo "                             <br><hr>" >> /tmp/ede.html
echo "</br>" >> /tmp/ede.html
echo "<td> Através deste e-mail a máquina <font color='#1E90FF'>$NDM</font> informa que o número de IP público mudou em <font color='#2E8B57'>$DTI.</font></td>" >> /tmp/ede.html
echo "</br>" >> /tmp/ede.html
echo "</br>" >> /tmp/ede.html
echo "<td> O novo número de IP Público da sua estrutura é: <font color='#00CED1'>$IPP</font> ao invés do antigo: <font color='#FF0000'>$CIP</font></td>" >> /tmp/ede.html
echo "</br>" >> /tmp/ede.html
echo "</br>" >> /tmp/ede.html
echo "<td>Esse número de IP está sendo fornecedo pela operadora <font color='#32CD32'>$OPR</font> na sua estrutura local<td>" >> /tmp/ede.html
echo "</br>" >> /tmp/ede.html
echo "</br>" >> /tmp/ede.html
echo "<td>Essa mensagem tem apenas o carater informativo quanto a mudança do número de IP Público</td>" >> /tmp/ede.html
echo "</br>" >> /tmp/ede.html
echo "</br>" >> /tmp/ede.html
echo "<td>Buscamos assim uma maior praticidade nas conexões VPN da empresa por conta de não possuírmos IPs fixos ou serviços pagos de DNS</td>" >> /tmp/ede.html
echo "</br>" >> /tmp/ede.html
echo "</br>" >> /tmp/ede.html
echo "<td>Para aproveitar essa informação 'feche' a conexão VPN através da numeração de IP: <font color='#00CED1'>$IPP</font> ao inves de qualquer outro nome de DNS</td>" >> /tmp/ede.html
echo "</br>" >> /tmp/ede.html
echo "</br>" >> /tmp/ede.html
echo "<td>Caso não tenha a necessidade de se conectar a VPN da empresa hoje Por favor desconsidere essa mensagem</td>" >> /tmp/ede.html
echo "</br>" >> /tmp/ede.html
echo "</br>" >> /tmp/ede.html
echo "<td> Esse é um e-mail automático, favor não resopndê-lo </td>" >> /tmp/ede.html
echo "</br>" >> /tmp/ede.html
echo "</br>" >> /tmp/ede.html
echo "</br>" >> /tmp/ede.html
echo "                             <br><hr>" >> /tmp/ede.html
echo "<b><td><b><font size='2'>Equipe de suporte </font></td></b> <a href='http://www.opentech.etc.br' alt='Opentech.etc.br' target='_blank'> <img title='opentech.etc' img width='105px' height='20px'  align='center' src='http://i63.tinypic.com/ncgjs7.jpg'/></a>>" >> /tmp/ede.html
echo "</br>" >> /tmp/ede.html
echo "</br>" >> /tmp/ede.html
echo "</body>" >> /tmp/ede.html
echo "</html>" >> /tmp/ede.html



###################====================------------ CODIGO HTML ------------====================###################

####===---|{ CASO OS IPS SEJAM (NOVO) E (VELHO) DIFERENTES
if [ $IPP != $CIP ]; then


####===---|{ ARMAZENANDO AS INFORMAÇÕES DO HTML PARA ENVIO VIA E-MAIL
CEM=`cat /tmp/ede.html`


####===---|{ ENVIO DE E-MAIL COM O CONTEUDO HTML
echo $CEM | mailx -r "E-MAIL_QUE_VAI_ENVIAR@gmail.com (Monitoramento)" -s "$(echo -e "Aviso! O Número de IP do Servidor de Manus Mudou!\nContent-Type: text/html")" E-MAIL_QUE_VAI_RECEBER_1@gmail.com,E-MAIL_QUE_VAI_RECEBER_2@gmail.com,E-MAIL_QUE_VAI_RECEBER_3@gmail.com < /tmp/ede.html



fi

####===---|{ LIMPANDO ARQUIVOS TEMPORARIOS
rm -f /tmp/ede.html

exit 0