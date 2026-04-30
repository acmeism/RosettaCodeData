function Narcissist
{
Param ( [string]$String )
If ( $String -eq $MyInvocation.MyCommand.Definition ) { 'Accept' }
Else { 'Reject' }
}
