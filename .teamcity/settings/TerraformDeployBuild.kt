package settings

import jetbrains.buildServer.configs.kotlin.v2019_2.BuildType
import shared.common.Agent
import shared.common.Architecture
import shared.common.DockerImage
import shared.common.build_steps.publishJiraProjectId
import shared.infrastructure.build_steps.publishTerraformVariables
import shared.infrastructure.build_steps.terraformConfig
import shared.infrastructure.build_steps.terraformDeploy
import shared.templates.ArtifactoryDockerLogin
import shared.templates.EnvironmentSetup


class TerraformDeployBuild(
    dockerImage: DockerImage,
    agent: Agent = Agent(architecture = Architecture.AMD64),
    scriptPath: String,
    projectName: String,
    deploymentWorkingDirectory: String = "",
) : BuildType({
    templates(
        EnvironmentSetup,
        ArtifactoryDockerLogin,
    )

    name = "Deploy terraform"

    steps {
        publishJiraProjectId(scriptPath)
        publishTerraformVariables(scriptPath)
        terraformConfig(scriptPath, dockerImage, deploymentWorkingDirectory)
        terraformDeploy(scriptPath, dockerImage, deploymentWorkingDirectory)
    }

    agent.add_to_requirements(this)

    params {
        param("terraform.state.key", "$projectName/%teamcity.build.branch%")
    }
})
