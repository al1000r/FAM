#-------------------------------------------------------
# POSITIVO TECNOLOGIA S.A.
#
# Script for FAMAR FIS Server Communication
#-------------------------------------------------------

param([parameter(Mandatory=$true)]$Message)

$currentExecutingPath = $MyInvocation.MyCommand.Path | Split-Path -Parent
$currentExecutingScript = $MyInvocation.MyCommand.Path

$encoding = [System.Text.ASCIIEncoding]::ASCII
.(Join-Path $currentExecutingPath "FIS_Config.ps1")
$message = "$Message`n" 

#Stablishing FIS Server Connection
$serverConn = new-object System.Net.Sockets.TcpClient($remoteHost, $port)

if($serverConn.Connected)
{

    #Sending message string to FIS Server
    $data = [System.Text.Encoding]::ASCII.GetBytes($message)
    $stream = $serverConn.GetStream()
    $stream.Write($data, 0, $data.Length)

    #Receiving message string from FIS Server 
    while(-not $stream.DataAvailable)
    {        
        $buffer = new-object System.Byte[] 1024
        $rawResponse = $stream.Read($buffer, 0, 1024)
        $response = $encoding.GetString($buffer,0,$rawResponse) 
        #$serverConn.Close()
        return $response
    }

    $serverConn.Close()   
}


#$Message1 = "BREQ|process=LEAKTEST|station=L1LEAK1|id=FG78AEX6`n"

#$Message2 = "BCMP|id=17142201EFNW|layer=01|bright=132|area=4.640,3.760|scandpi=1000|timestamp=171007153801|caldate=NOT_executed|defacclvl=4.0|chkacclvl=3.0|appert=9124|errors=0|ualig=ON|insptime=113.3|status=PASS`n"