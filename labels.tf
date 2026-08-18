locals {
  supported_releases = {
    "2026.06" = {
      lts       = false
      backports = false
    }
  }

  release_labels = merge(
    {
      "release/rolling" = {
        color       = "bfd4f2"
        description = "Affects the rolling release"
      }
    },
    {
      for version, release in local.supported_releases : "release/${version}" => {
        color       = "bfd4f2"
        description = "Affects the ${version} ${release.lts ? "LTS" : "stable"} release"
      }
    },
    {
      for version, release in local.supported_releases : "backport/${version}" => {
        color       = "fef2c0"
        description = "Pick this pull request into the ${version} branch"
      } if release.backports
    },
  )

  common_labels = {
    "type/bug" = {
      color       = "d73a4a"
      description = "Something isn't working"
    }
    "type/feature" = {
      color       = "a2eeef"
      description = "New feature or request"
    }
    "needs-info" = {
      color       = "d876e3"
      description = "Further information is requested"
    }

    "topic/docs" = {
      color       = "0075ca"
      description = "Improvements or additions to documentation"
    }
    "topic/security" = {
      color       = "b60205"
      description = "Security relevant issue or fix"
    }

    "triage/accepted" = {
      color       = "0e8a16"
      description = "This issue has been accepted and will be scheduled"
    }
    "triage/needs-milestone" = {
      color       = "fbca04"
      description = "This issue needs to be scheduled in a milestone"
    }
    "triage/duplicate" = {
      color       = "cfd3d7"
      description = "This issue or pull request already exists"
    }
    "triage/invalid" = {
      color       = "e4e669"
      description = "This doesn't seem right"
    }
    "triage/wontfix" = {
      color       = "ffffff"
      description = "This will not be worked on"
    }
    "needs triage" = {
      color       = "ededed"
      description = "Waiting for an initial assessment"
    }

    "dependencies" = {
      color       = "0366d6"
      description = "Pull requests that update a dependency file"
    }
    "github_actions" = {
      color       = "000000"
      description = "Pull requests that update GitHub Actions code"
    }
  }

  canopybmc_labels = {
    "target/hpe/all" = {
      color       = "c5def5"
      description = "Affects every HPE platform"
    }
    "target/hpe-proliant-g11" = {
      color       = "c5def5"
      description = "Affects HPE ProLiant Gen11 platforms"
    }

    "target/asus/all" = {
      color       = "c5def5"
      description = "Affects every ASUS platform"
    }
    "target/kommando-ipmi-card" = {
      color       = "c5def5"
      description = "Affects the ASUS Kommando IPMI card"
    }

    "target/qemu" = {
      color       = "c5def5"
      description = "Affects the QEMU target"
    }
    "target/all" = {
      color       = "c5def5"
      description = "Affects every supported platform"
    }

    "upstream/openbmc" = {
      color       = "5319e7"
      description = "Root cause or fix belongs to upstream OpenBMC"
    }
    "upstream/linux" = {
      color       = "5319e7"
      description = "Root cause or fix belongs to the Linux kernel"
    }
    "upstream/u-boot" = {
      color       = "5319e7"
      description = "Root cause or fix belongs to U-Boot"
    }
    "upstream/openembedded" = {
      color       = "5319e7"
      description = "Root cause or fix belongs to Yocto or OpenEmbedded"
    }
    "upstream/submitted" = {
      color       = "5319e7"
      description = "A change has been sent upstream and is waiting for review"
    }
    "upstream/backport" = {
      color       = "5319e7"
      description = "Backported an upstream patch that either got merged or is still pending"
    }
    "upstream/pending-submission" = {
      color       = "5319e7"
      description = "Not submitted to upstream yet and will be tracked as a downstream patch"
    }

    "needs-vendor" = {
      color       = "fbca04"
      description = "Blocked on information, documentation or a fix from the hardware vendor"
    }
    "needs-hardware" = {
      color       = "fbca04"
      description = "Blocked on access to physical hardware to reproduce or verify"
    }

    "topic/build" = {
      color       = "1d76db"
      description = "Yocto layers, BitBake recipes and the build system"
    }
    "topic/linux" = {
      color       = "1d76db"
      description = "Kernel configuration, drivers and device trees"
    }
    "topic/u-boot" = {
      color       = "1d76db"
      description = "Bootloader and early boot"
    }
    "topic/webui" = {
      color       = "1d76db"
      description = "Web user interface"
    }
    "topic/redfish" = {
      color       = "1d76db"
      description = "Redfish and bmcweb"
    }
    "topic/ipmi" = {
      color       = "1d76db"
      description = "IPMI interfaces and OEM commands"
    }
    "topic/sensors" = {
      color       = "1d76db"
      description = "Sensors, thermal and fan control"
    }
    "topic/power" = {
      color       = "1d76db"
      description = "Host and chassis power, state management and boot flow"
    }
    "topic/networking" = {
      color       = "1d76db"
      description = "Network configuration and connectivity"
    }
    "topic/ci" = {
      color       = "1d76db"
      description = "CI, test infrastructure and release automation"
    }

    "type/regression" = {
      color       = "d93f0b"
      description = "Worked in an earlier release and broke since"
    }
    "type/hardware-enablement" = {
      color       = "0e8a16"
      description = "Bring-up or enablement of new hardware"
    }
    "backport/needed" = {
      color       = "fef2c0"
      description = "Needs a backport, target release not decided yet"
    }
    "backport/automated" = {
      color       = "fef2c0"
      description = "Pull request opened automatically by the backport bot"
    }
  }
}
