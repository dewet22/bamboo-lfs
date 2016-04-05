# bamboo-lfs
Helper scripts to enable git LFS support on [Atlassian Bamboo CI server](https://www.atlassian.com/software/bamboo).
Ever since Atlassian Bitbucket Server (f.k.a. Stash) started supporting LFS, loyal customers who use the complete Atlassian suite discovered a relative lack of support at the Bamboo end for LFS. This is my small contribution to the Atlassian community to try and remedy this problem.

## Instructions
- Place `git-checkout.sh` somewhere in your path (or at least somewhere the Bamboo user can execute it from) and remember to set the +x bit
- Remove the existing "Source Code Checkout" step in your build plan, and replace it with a script task that calls `git-checkout.sh` instead. It doesn't need any parameters, it takes everything from environment variables that Bamboo sets up automatically at the beginning of the run
- Having set up your stash repo as a "linked repository" should ensure that ssh keys are working too, and therefore Bamboo has read/write access automagically
 - You can verify this on the stash side by going to the repo configuration -> access keys. There should be a read-write key labeled with something bamboo-related. If you don't have one, you can add the public key from `~bamboouser/.ssh/id_rsa.pub` 
- You will quite likely need to remove the old build directory from `<data_dir>/xml-data/build-dir/BUILD-KEY`. This should be completely safe since Bamboo will just recreate that on the next run

## Features
- No passwords or ssh keys needed, it reuses the existing Bamboo-Stash integration
- Zero configuration: everything is done automagically via Bamboo's environment variables
- Supports branches and checking out specific revisions -- essential if you have per-branch build plans enabled, or if you do deployments from successful builds
- Plays nice with new builds and rebuilds, where the working directory has differing state
- Works fine on remote agents too

## Sample log
```
simple	04-Apr-2016 15:33:26	Build PlanName - Run tests #229 (PLAN-JOB1-229) started building on agent Local #2
simple	04-Apr-2016 15:33:26	
simple	04-Apr-2016 15:33:27	Build working directory is /..datadir../xml-data/build-dir/PLAN-JOB1
simple	04-Apr-2016 15:33:27	Executing build PlanName - Run tests #229 (PLAN-JOB1-229)
simple	04-Apr-2016 15:33:27	Running pre-build action: VCS Version Collector
command	04-Apr-2016 15:33:27	Substituting variable: ${bamboo.build.working.directory} with /..datadir../xml-data/build-dir/PLAN-JOB1
command	04-Apr-2016 15:33:27	Substituting variable: ${bamboo.planRepository.1.repositoryUrl} with ssh://git@stash.yourdomain.com:7999/main/repo.git
simple	04-Apr-2016 15:33:27	Starting task 'Git checkout' of type 'com.atlassian.bamboo.plugins.scripttask:task.builder.script'
command	04-Apr-2016 15:33:27	Beginning to execute external process for build 'PlanName - Run tests #229 (PLAN-JOB1-229)'\n ... running command line: \n/bin/sh ../../../git-checkout.sh\n ... in: /..datadir../xml-data/build-dir/PLAN-JOB1\n ... using extra environment variables: \nbamboo_planRepository_1_branch=master\nbamboo_repository_revision_number=e86...f07\nbamboo_resultsUrl=https://bamboo.yourdomain.com/browse/PLAN-JOB1-229\nbamboo_planRepository_1_name=repo\nbamboo_build_working_directory=/..datadir../xml-data/build-dir/PLAN-JOB1\nbamboo_buildKey=PLAN-JOB1\nbamboo_capability_system_builder_gradlew_Gradle_Wrapper=.\nbamboo_shortPlanName=repo\nbamboo_planRepository_name=repo\nbamboo_buildNumber=229\nbamboo_capability_system_builder_command_Python_2_7=/usr/bin/python2.7\nbamboo_shortJobName=Run tests\nbamboo_buildResultsUrl=https://bamboo.yourdomain.com/browse/PLAN-JOB1-229\nbamboo_planRepository_repositoryUrl=ssh://git@stash.yourdomain.com:7999/main/repo.git\nbamboo_agentId=2260993\nbamboo_planName=PlanName\nbamboo_repository_16449537_revision_number=e86...f07\nbamboo_shortPlanKey=PY\nbamboo_shortJobKey=JOB1\nbamboo_planRepository_revision=e86...f07\nbamboo_repository_16449537_git_username=\nbamboo_repository_previous_revision_number=31c...023\nbamboo_buildTimeStamp=2016-04-04T15:32:55.815Z\nbamboo_planRepository_previousRevision=31c...023\nbamboo_repository_16449537_previous_revision_number=31c...023\nbamboo_buildResultKey=PLAN-JOB1-229\nbamboo_repository_git_branch=master\nbamboo_repository_branch_name=master\nbamboo_buildPlanName=PlanName - Run tests\nbamboo_repository_16449537_git_branch=master\nbamboo_planRepository_1_revision=e86...f07\nbamboo_repository_name=repo\nbamboo_repository_16449537_branch_name=master\nbamboo_capability_system_docker_executable=/usr/bin/docker\nbamboo_planRepository_branch=master\nbamboo_agentWorkingDirectory=/..datadir../xml-data/build-dir\nbamboo_capability_system_git_executable=/usr/bin/git\nbamboo_planRepository_1_previousRevision=31c...023\nbamboo_repository_git_username=\nbamboo_planRepository_1_type=stash-rep\nbamboo_planRepository_branchName=master\nbamboo_capability_system_builder_command_Python_3_4=/usr/bin/python3.4\nbamboo_planRepository_type=stash-rep\nbamboo_planRepository_1_username=\nbamboo_repository_git_repositoryUrl=ssh://git@stash.yourdomain.com:7999/main/repo.git\nbamboo_repository_16449537_name=repo\nbamboo_capability_system_builder_node_Node_js=/usr/bin/node\nbamboo_working_directory=/..datadir../xml-data/build-dir/PLAN-JOB1\nbamboo_planKey=PLAN\nbamboo_planRepository_1_repositoryUrl=ssh://git@stash.yourdomain.com:7999/main/repo.git\nbamboo_planRepository_username=\nbamboo_capability_system_jdk_JDK_1_8=/usr/lib/jvm/java-8-oracle\nbamboo_repository_16449537_git_repositoryUrl=ssh://git@stash.yourdomain.com:7999/main/repo.git\nbamboo_planRepository_1_branchName=master\n
error	04-Apr-2016 15:33:27	+ REPO=ssh://git@stash.yourdomain.com:7999/main/repo.git
build	04-Apr-2016 15:33:27	Repo: ssh://git@stash.yourdomain.com:7999/main/repo.git
build	04-Apr-2016 15:33:27	Working directory: /..datadir../xml-data/build-dir/PLAN-JOB1
error	04-Apr-2016 15:33:27	+ WORKDIR=/..datadir../xml-data/build-dir/PLAN-JOB1
build	04-Apr-2016 15:33:27	Branch: master
error	04-Apr-2016 15:33:27	+ BRANCH=master
build	04-Apr-2016 15:33:27	Commit: e86...f07
error	04-Apr-2016 15:33:27	+ COMMIT=e86...f07
error	04-Apr-2016 15:33:27	+ [ ssh://git@stash.yourdomain.com:7999/main/repo.git =  ]
build	04-Apr-2016 15:33:27	Updating existing repo...
error	04-Apr-2016 15:33:27	+ [ /..datadir../xml-data/build-dir/PLAN-JOB1 =  ]
error	04-Apr-2016 15:33:27	+ [ master =  ]
error	04-Apr-2016 15:33:27	+ [ e86...f07 =  ]
error	04-Apr-2016 15:33:27	+ echo Repo: ssh://git@stash.yourdomain.com:7999/main/repo.git
error	04-Apr-2016 15:33:27	+ echo Working directory: /..datadir../xml-data/build-dir/PLAN-JOB1
error	04-Apr-2016 15:33:27	+ echo Branch: master
error	04-Apr-2016 15:33:27	+ echo Commit: e86...f07
error	04-Apr-2016 15:33:27	+ [ ! -d /..datadir../xml-data/build-dir/PLAN-JOB1 ]
error	04-Apr-2016 15:33:27	+ cd /..datadir../xml-data/build-dir/PLAN-JOB1
error	04-Apr-2016 15:33:27	+ [ ! -d .git ]
error	04-Apr-2016 15:33:27	+ git config --get remote.origin.url
error	04-Apr-2016 15:33:27	+ repo=ssh://git@stash.yourdomain.com:7999/main/repo.git
error	04-Apr-2016 15:33:27	+ [ ssh://git@stash.yourdomain.com:7999/main/repo.git != ssh://git@stash.yourdomain.com:7999/main/repo.git ]
error	04-Apr-2016 15:33:27	+ echo Updating existing repo...
error	04-Apr-2016 15:33:27	+ git fetch --prune
error	04-Apr-2016 15:33:28	From ssh://stash.yourdomain.com:7999/main/repo
error	04-Apr-2016 15:33:28	 x [deleted]         (none)     -> origin/feature/something
error	04-Apr-2016 15:33:29	   31c1a0c..e86949d  master     -> origin/master
error	04-Apr-2016 15:33:29	   aa38682..98f71e9  feature/something-else -> origin/feature/something-else
error	04-Apr-2016 15:33:29	 * [new tag]         PLAN217-32 -> PLAN217-32
build	04-Apr-2016 15:33:30	Removing ..../
error	04-Apr-2016 15:33:30	 * [new tag]         PLAN219-15 -> PLAN219-15
build	04-Apr-2016 15:33:30	Removing ..../
error	04-Apr-2016 15:33:30	+ git clean -xdf
build	04-Apr-2016 15:33:30	Removing ext/__pycache__/
error	04-Apr-2016 15:33:30	+ git checkout -f -B master e86...f07
build	04-Apr-2016 15:33:30	Removing .../__pycache__/
error	04-Apr-2016 15:33:30	Reset branch 'master'
build	04-Apr-2016 15:33:30	Removing ....
error	04-Apr-2016 15:33:30	+ git clean -xdf
build	04-Apr-2016 15:33:30	Removing .../....cpython-35m-x86_64-linux-gnu.so
build	04-Apr-2016 15:33:30	Your branch is up-to-date with 'origin/master'.
simple	04-Apr-2016 15:33:30	Finished task 'Git checkout' with result: Success
simple	04-Apr-2016 15:33:30	Starting task 'Run tests' of type 'com.atlassian.bamboo.plugins.scripttask:task.builder.script'
...
```
