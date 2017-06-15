#!/bin/bash


###  #####################################################  ###
###   Captura o IP da conexão e registra quando ele mudar   ###
###  Por Luiz peterli (suporte@opentech.etc.br) em 22/02/17  ###
###  #####################################################  ###


###  #######################################################################  ###
###  Esse Script utilza as aplicações curl e sendmail/postfix para funcionar  ###
###  ######################################################################## ###



####===---|{ DATA E HORA DE INICIO DO PROCEDIMENTO
DTI=`(date --date "now" +%A_%d_de_%B_às_%H:%M:%S_hrs)| sed 's,_, ,g'`



####===---|{ UPTIME DO SERVIDOR
UPM=`uptime | cut -d " " -f3,4,5,6,7|sed 's/,//'|sed 's/,//'`



####===---|{ ARMAZENANDO O NOME DA MAQUINA EM UMA VARIAVEL
NDM=`/bin/hostname`



####===---|{ VERIFICA SE O SERVIÇO DA VPN ESTA RODANDO (VPN PPTPD)
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



####===---|{ STATUS DAS PORTAS DE CONEXÂO DA VPN (VPN PPTPD)
PCV=`iptables -nvL |grep 1194 |awk '{print $3}'`



####===---|{ ARMAZENAR A NOVA INFORMACAO DO IP PUBLICO EM UM ARQUIVO
echo $IPP > /tmp/vip.txt



####===---|{ CRIANDO O ARQUIVO TEMPORARIO PARA O ARMAZENAMENTO DA MENSAGEM DE EMAIL
rm -f /tmp/ede.html; touch /tmp/ede.html



####===---|{ CUSTOMIZAÇÃO DO LOG - ENDEREÇOS DE IMAGENS HTML

LOGO="http://i67.tinypic.com/rk994j.jpg"
ASSI="http://i63.tinypic.com/ncgjs7.jpg"



####===---|{ INICIO DO CODIGO HTML



echo "<!--Report html by opentehc.etc.br-->" >> /tmp/ede.html
echo "<html>" >> /tmp/ede.html
echo "<head>" >> /tmp/ede.html
echo "<title>Monitoramento de Recursos</title>" >> /tmp/ede.html
echo "<meta http-equiv='Content-Type' content='text/html;charset=utf-8'/>" >> /tmp/ede.html
echo "</head>" >> /tmp/ede.html
echo "<table width='100%' border='0' cellspacing='0' cellpadding='0' align='center'>" >> /tmp/ede.html
echo "<br>" >> /tmp/ede.html
echo "<!--Início do Título do Relatório-->" >> /tmp/ede.html
echo "<tr><td><hr align='left' width='580' size='1' color=black></td></tr>" >> /tmp/ede.html
echo "<table width='580'>" >> /tmp/ede.html
echo "<tr><td><img title='Relatorio elaborado por Luiz Peterli -- suporte@opentech.etc.br' img width='50px' height='56px' src='$LOGO'/></td><td><b><font size='5'>Relatório de Mudança de IP Público</b></font></td></tr>" >> /tmp/ede.html
echo "</table>" >> /tmp/ede.html
echo "<tr><td><hr align='left' width='580' size='1' color=black></td></tr>" >> /tmp/ede.html
echo "<!--Final do Título do Relatório-->" >> /tmp/ede.html
echo "<br>" >> /tmp/ede.html
echo "<br>" >> /tmp/ede.html
echo "<!--Final das informações técnicas-->" >> /tmp/ede.html
echo "<br>" >> /tmp/ede.html
echo "<!--Título da análise-->" >> /tmp/ede.html
echo "<table border=0 width='550'>" >> /tmp/ede.html
echo "<tr><td><font size='4'><b>Informações do servidor de VPN</font></b></td><tr>" >> /tmp/ede.html
echo "</table>" >> /tmp/ede.html
echo "<!--Fim do Título da análise-->" >> /tmp/ede.html
echo "<!---->" >> /tmp/ede.html
echo "<!---->" >> /tmp/ede.html
echo "<p>" >> /tmp/ede.html
echo "<!--Início das informações técnicas-->" >> /tmp/ede.html
echo "<!--A tabela a baixo pode abrir desconfigurada em um teste no seu navegador mas ela está no padrão pra visualização no webmail ou no cliene de email-->" >> /tmp/ede.html
echo "<table border=1 width='500 align='left'>" >> /tmp/ede.html
echo "<tr><td bgcolor='WhiteSmoke' width='30%' height='30' valign='middle' align='left'><b>Nome do Servidor</b></td>          <td width='50%' height='30' valign='middle' align='center'><font color='#00FA9A'><b>$NDM</b></font></td></tr>" >> /tmp/ede.html
echo "<tr><td bgcolor='WhiteSmoke' width='30%' height='30' valign='middle' align='left'><b>IP Público Antigo</b></td>         <td width='50%' height='30' valign='middle' align='center'><font color='#FF0000'><b>$CIP</b></font></td></tr>" >> /tmp/ede.html
echo "<tr><td bgcolor='WhiteSmoke' width='30%' height='30' valign='middle' align='left'><b>IP Público Novo</b></td>           <td width='50%' height='30' valign='middle' align='center'><font color='#1E90FF'><b>$IPP</b></font></td></tr>" >> /tmp/ede.html
echo "<tr><td bgcolor='WhiteSmoke' width='30%' height='30' valign='middle' align='left'><b>Operadora de internet</b></td>     <td width='50%' height='30' valign='middle' align='center'><font color='#FF7F50'><b>$OPR</b></font></td></tr>" >> /tmp/ede.html
echo "<tr><td bgcolor='WhiteSmoke' width='30%' height='30' valign='middle' align='left'><b>Data e hora da mudança</b></td>    <td width='50%' height='30' valign='middle' align='center'><font color='#FFC125'><b>$DTI</b></font></td></tr>" >> /tmp/ede.html
echo "<tr><td bgcolor='WhiteSmoke' width='30%' height='30' valign='middle' align='left'><b>Tempo de Servidor ligado</b></td>  <td width='50%' height='30' valign='middle' align='center'><font color='#912CEE'><b>$UPM</b></font></td></tr>" >> /tmp/ede.html
echo "<tr><td bgcolor='WhiteSmoke' width='30%' height='30' valign='middle' align='left'><b>Status da VPN no Servidor</b></td> <td width='50%' height='30' valign='middle' align='center'><font color='#00FF7F'><b>$SPT</b></font></td></tr>" >> /tmp/ede.html
echo "<tr><td bgcolor='WhiteSmoke' width='30%' height='30' valign='middle' align='left'><b>Status das portas da VPN</b></td>  <td width='50%' height='30' valign='middle' align='center'><font color='#FF6EB4'><b>$PCV</b></font></td></tr>" >> /tmp/ede.html
echo "</table>" >> /tmp/ede.html
echo "<!--Final das informações técnicas-->" >> /tmp/ede.html
echo "<br>" >> /tmp/ede.html
echo "<br>" >> /tmp/ede.html
echo "<br>" >> /tmp/ede.html
echo "<!--Início da descrição da análise-->" >> /tmp/ede.html
echo "<tr><td><hr align='left' width='580' size='1' color=black></td></tr>" >> /tmp/ede.html
echo "<table border=0 width='80%'>" >> /tmp/ede.html
echo "<td><font size='4'><b>Informativo de mudança do número de IP Público</font></b></td>" >> /tmp/ede.html
echo "</table>" >> /tmp/ede.html
echo "<tr><td><hr align='left' width='580' size='1' color=black></td></tr>" >> /tmp/ede.html
echo "<!--Fim da descrição da análise-->" >> /tmp/ede.html
echo "<br>" >> /tmp/ede.html
echo "<!--Início do Texto descritivo-->" >> /tmp/ede.html
echo "<table border=0 width='80%'>" >> /tmp/ede.html
echo "Através deste e-mail a máquina <font color='#00FA9A'>$NDM</font> informa que o número de IP público mudou em <font color='#FFC125'>$DTI</font>" >> /tmp/ede.html
echo "<br>" >> /tmp/ede.html
echo "<br>" >> /tmp/ede.html
echo "O novo número de IP Público da sua estrutura é <font color='#1E90FF'>$IPP</font> ao invés do antigo <font color='#FF0000'>$CIP</font>" >> /tmp/ede.html
echo "<br>" >> /tmp/ede.html
echo "<br>" >> /tmp/ede.html
echo "Esse número de IP está sendo fornecedo pela operadora <font color='#FF7F50'>$OPR</font> na sua estrutura local" >> /tmp/ede.html
echo "<br>" >> /tmp/ede.html
echo "<br>" >> /tmp/ede.html
echo "Essa mensagem é automática, ela é um informativo quanto a mudança do número de IP Público" >> /tmp/ede.html
echo "<br>" >> /tmp/ede.html
echo "<br>" >> /tmp/ede.html
echo "Para aproveitar essa informação 'feche' a conexão VPN através da numeração de IP: <font color='#1E90FF'>$IPP</font>" >> /tmp/ede.html
echo "<br>" >> /tmp/ede.html
echo "<br>" >> /tmp/ede.html
echo "Essa é uma mensagem automática, favor não respondê-la." >> /tmp/ede.html
echo "<br>" >> /tmp/ede.html
echo "<br>" >> /tmp/ede.html
echo "Atenciosamente" >> /tmp/ede.html
echo "</table>" >> /tmp/ede.html
echo "<!--Final do Texto descritivo-->" >> /tmp/ede.html
echo "<br>" >> /tmp/ede.html
echo "<!--Início da Assinatura-->" >> /tmp/ede.html
echo "<tr><td><hr align='left' width='580' size='1' color=black></td></tr>" >> /tmp/ede.html
echo "<table border=0 width='95%'>" >> /tmp/ede.html
echo "<tr><b><td valign='middle' align='left><font size='1'>Equipe de suporte OpenTech.etc <a href='http://www.opentech.etc.br' alt='Opentech.etc.br' target='_blank'> <img title='opentech.etc' img width='105px' height='20px'  align='center' src='$ASSI'/></a></font></b></td></tr>" >> /tmp/ede.html
echo "</table>" >> /tmp/ede.html
echo "<!--Final da Assinatura-->" >> /tmp/ede.html
echo "<br>" >> /tmp/ede.html
echo "</table>" >> /tmp/ede.html
echo "<body>" >> /tmp/ede.html



####===---|{ FINAL DO CODIGO HTML



####===---|{ CASO OS IPS SEJAM (NOVO) E (VELHO) DIFERENTES
if [ $IPP != $CIP ]; then

####===---|{ ENVIANDO O LOG EM HTML POR EMAIL COM FORMATAÇÃO UTF-8 USANDO O SENDMAIL
mailx -r "EMAIL_QUE_VAI_ENVIAR_O_LOG@gmail.com (APILIDO OD EMAIL EX: Monitoramento)" -s "$(echo -e "TITULO DO SUE EMAIL (NÃO APAGAR DO (\N) EM DIANTE>>)\nContent-Type: text/html")" EMAIL_DO_DESTINATARIO_1@gmail.com,EMAIL_DO_DESTINATARIO_2@gmail.com,E POR AI VAI...  < /tmp/ede.html

fi



####===---|{ LIMPANDO ARQUIVOS TEMPORARIOS
rm -f /tmp/ede.html



exit 0
 
 
