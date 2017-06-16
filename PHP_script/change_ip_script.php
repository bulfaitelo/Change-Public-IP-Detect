<?php

/**
 * Arquivo change_ip_script.php;
*/

/**  
* Script para notificação via Email de alteração de IP.
* @author Thiago Rodrigues | Bulfaitelo
* @version 1.0;
* @package Script;
* @category Script;
*/

// DATA E HORA DE INICIO DO PROCEDIMENTO
$DTI=shell_exec(`(date --date "now" +%A_%d_de_%B_às_%H:%M:%S_hrs)| sed 's,_, ,g'`);

// UPTIME DO SERVIDOR
$UPM=shell_exec(`uptime | cut -d " " -f3,4,5,6,7|sed 's/,//'|sed 's/,//'`);

// ARMAZENANDO O NOME DA MAQUINA EM UMA VARIAVEL
$NDM=shell_exec(`/bin/hostname`);

// VERIFICA SE O SERVIÇO DA VPN ESTA RODANDO (VPN PPTPD)
$SPT=shell_exec(`service pptpd status |grep "active" |cut -d " " -f5,6`);

// ARMAZENANDO AS INFORMACOES DE IP EM UM ARQUIVO PARA ANALISE
$details = json_decode(file_get_contents("http://ipinfo.io/json"));
$IP = $details->ip;

echo "<html>
<head>
<!--Report html by opentehc.etc.br-->
<title>Monitoramento de Recursos</title>
<meta http-equiv='Content-Type' content='text/html;charset=utf-8'/>
</head>
<table width='100%' border='0' cellspacing='0' cellpadding='0' align='center'>
<br>
<!--Início do Título do Relatório-->
<tr><td><hr align='left' width='580' size='1' color=black></td></tr>
<table width='580'>
<tr><td><img title='Relatorio elaborado por Luiz Peterli -- suporte@opentech.etc.br' img width='50px' height='56px' src='http://i67.tinypic.com/rk994j.jpg'/></td><td><b><font size='5'>Relatório de Mudança de IP Público</b></font></td></tr>
</table>
<tr><td><hr align='left' width='580' size='1' color=black></td></tr>
<!--Final do Título do Relatório-->
<br>
<br>
<!--Final das informações técnicas-->
<br>
<!--Título da análise-->
<table border=0 width='550'>
<tr><td><font size='4'><b>Informações do servidor de VPN</font></b></td><tr>
</table>
<!--Fim do Título da análise-->
<!---->
<!---->
<p>
<!--Início das informações técnicas-->
<!--A tabela a baixo pode abrir desconfigurada em um teste no seu navegador mas ela está no padrão pra visualização no webmail ou no cliene de email-->
<table border=1 width='500 align='left'>
<tr><td bgcolor='WhiteSmoke' width='30%' height='30' valign='middle' align='left'><b>Nome do Servidor</b></td>          <td width='50%' height='30' valign='middle' align='center'><font color='#00FA9A'><b>$NDM</b></font></td></tr>
<tr><td bgcolor='WhiteSmoke' width='30%' height='30' valign='middle' align='left'><b>IP Público Antigo</b></td>         <td width='50%' height='30' valign='middle' align='center'><font color='#FF0000'><b>$CIP</b></font></td></tr>
<tr><td bgcolor='WhiteSmoke' width='30%' height='30' valign='middle' align='left'><b>IP Público Novo</b></td>           <td width='50%' height='30' valign='middle' align='center'><font color='#1E90FF'><b>$IPP</b></font></td></tr>
<tr><td bgcolor='WhiteSmoke' width='30%' height='30' valign='middle' align='left'><b>Operadora de internet</b></td>     <td width='50%' height='30' valign='middle' align='center'><font color='#FF7F50'><b>$OPR</b></font></td></tr>
<tr><td bgcolor='WhiteSmoke' width='30%' height='30' valign='middle' align='left'><b>Data e hora da mudança</b></td>    <td width='50%' height='30' valign='middle' align='center'><font color='#FFC125'><b>$DTI</b></font></td></tr>
<tr><td bgcolor='WhiteSmoke' width='30%' height='30' valign='middle' align='left'><b>Tempo de Servidor ligado</b></td>  <td width='50%' height='30' valign='middle' align='center'><font color='#912CEE'><b>$UPM</b></font></td></tr>
<tr><td bgcolor='WhiteSmoke' width='30%' height='30' valign='middle' align='left'><b>Status da VPN no Servidor</b></td> <td width='50%' height='30' valign='middle' align='center'><font color='#00FF7F'><b>$SPT</b></font></td></tr>
<tr><td bgcolor='WhiteSmoke' width='30%' height='30' valign='middle' align='left'><b>Status das portas da VPN</b></td>  <td width='50%' height='30' valign='middle' align='center'><font color='#FF6EB4'><b>$PCV</b></font></td></tr>
</table>
<!--Final das informações técnicas-->
<br>
<br>
<br>
<!--Início da descrição da análise-->
<tr><td><hr align='left' width='580' size='1' color=black></td></tr>
<table border=0 width='80%'>
<td><font size='4'><b>Informativo de mudança do número de IP Público</font></b></td>
</table>
<tr><td><hr align='left' width='580' size='1' color=black></td></tr>
<!--Fim da descrição da análise-->
<br>
<!--Início do Texto descritivo-->
<table border=0 width='80%'>
Através deste e-mail a máquina <font color='#00FA9A'>$NDM</font> informa que o número de IP público mudou em <font color='#FFC125'>$DTI</font>
<br>
<br>
O novo número de IP Público da sua estrutura é <font color='#1E90FF'>$IPP</font> ao invés do antigo <font color='#FF0000'>$CIP</font>
<br>
<br>
Esse número de IP está sendo fornecedo pela operadora <font color='#FF7F50'>$OPR</font> na sua estrutura local
<br>
<br>
Essa mensagem é automática, ela é um informativo quanto a mudança do número de IP Público
<br>
<br>
Para aproveitar essa informação 'feche' a conexão VPN através da numeração de IP: <font color='#1E90FF'>$IPP</font>
<br>
<br>
Essa é uma mensagem automática, favor não respondê-la.
<br>
<br>
Atenciosamente
</table>
<!--Final do Texto descritivo-->
<br>
<!--Início da Assinatura-->
<tr><td><hr align='left' width='580' size='1' color=black></td></tr>
<table border=0 width='95%'>
<tr><b><td valign='middle' align='left><font size='1'>Equipe de suporte OpenTech.etc<a href='http://www.opentech.etc.br' alt='Opentech.etc.br' target='_blank'> <img title='opentech.etc' img width='105px' height='20px'  align='center' src='http://i63.tinypic.com/ncgjs7.jpg'/></a></font></b></td></tr>
</table>
<!--Final da Assinatura-->
<br>
</table>
<body> 
";
