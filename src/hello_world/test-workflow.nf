#!/usr/bin/env nextflow

// Equivalent of a CommandLineTool class in CWL
process sayHello {
    // Set the container image to use per process
    container 'ubuntu:latest'
    // Since we dont use an input we only set output
    output:
    path 'hello.txt'
    // Script to be executed
    script:
    """
    #!/bin/sh
    echo 'Hello World!' > hello.txt
    """
}
// Equivalent of a Workflow class in CWL
workflow {
    sayHello()
}
