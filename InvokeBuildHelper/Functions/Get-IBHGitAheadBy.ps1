<#
    .SYNOPSIS
        Check if the git repository is ahead of the origin.

    .DESCRIPTION
        Return the number of commits ahead of the origin repository. It will
        return 0, if we are not ahead.
#>
function Get-IBHGitAheadBy
{
    [CmdletBinding()]
    [OutputType([System.Int32])]
    param ()

    $status = git -c core.quotepath=false -c color.status=false status -uno --short --branch
    $status = $status -join "`n"

    $aheadBy = 0
    if ($status -match '\[(?:ahead (?<ahead>\d+))?(?:, )?(?:behind (?<behind>\d+))?(?<gone>gone)?\]')
    {
        if ($null -ne $Matches -and $Matches.Keys -contains 'ahead')
        {
            $aheadBy = [System.Int32] $Matches['ahead']
        }
    }

    return $aheadBy
}