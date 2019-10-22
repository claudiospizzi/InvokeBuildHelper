<#
    .SYNOPSIS
        Upload an artifact to GitHub.
#>
function Publish-IBHGitHubArtifact
{
    [CmdletBinding(SupportsShouldProcess = $true)]
    param
    (
        # GitHub repo name.
        [Parameter(Mandatory = $true)]
        [System.String]
        $RepoName,

        # Authentication token.
        [Parameter(Mandatory = $true)]
        [System.Security.SecureString]
        $Token,

        # Release id.
        [Parameter(Mandatory = $true)]
        [System.String]
        $ReleaseId,

        # Artifact file name.
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        # Artifact path.
        [Parameter(Mandatory = $true)]
        [System.String]
        $Path
    )

    # Add TLS 1.2 for GitHub
    if (([System.Net.ServicePointManager]::SecurityProtocol -band [System.Net.SecurityProtocolType]::Tls12) -ne [System.Net.SecurityProtocolType]::Tls12)
    {
        [System.Net.ServicePointManager]::SecurityProtocol += [System.Net.SecurityProtocolType]::Tls12
    }

    # Upload artifact to GitHub
    $invokeRestMethodSplat = @{
        Method          = 'Post'
        Uri             = "https://uploads.github.com/repos/$RepoName/releases/$ReleaseId/assets?name=$Name"
        Headers         = @{
            'Accept'        = 'application/vnd.github.v3+json'
            'Authorization' = "token $Token"
            'Content-Type'  = 'application/zip'
        }
        InFile          = $Path
    }
    Invoke-RestMethod @invokeRestMethodSplat -ErrorAction Stop
}