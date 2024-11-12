process exampleProcess {
    container = 'your-docker-image' // Replace with your Docker image
    script:
    """
    echo "Running example process"
    """
}

// ...existing code...

process anotherProcess {
    container = 'another-docker-image' // Replace with another Docker image if needed
    script:
    """
    echo "Running another process"
    """
}

// ...existing code...