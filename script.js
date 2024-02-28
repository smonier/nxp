// Expanded MIME type to icon image map
function getFontAwesomeIconFromMIME(mimeType) {
    switch(mimeType) {
        case 'application/pdf':
            return 'fas fa-file-pdf'; // PDF file
        case 'application/msword':
        case 'application/vnd.openxmlformats-officedocument.wordprocessingml.document':
            return 'fas fa-file-word'; // Word file
        case 'application/vnd.ms-excel':
        case 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet':
            return 'fas fa-file-excel'; // Excel file
        case 'application/vnd.ms-powerpoint':
        case 'application/vnd.openxmlformats-officedocument.presentationml.presentation':
            return 'fas fa-file-powerpoint'; // PowerPoint file
        case 'text/plain':
            return 'fas fa-file-alt'; // Text file
        case 'image/jpeg':
        case 'image/png':
        case 'image/gif':
            return 'fas fa-file-image'; // Image file
        case 'video/mp4':
        case 'video/mpeg':
            return 'fas fa-file-video'; // Video file
        case 'audio/mpeg':
        case 'audio/mp3':
            return 'fas fa-file-audio'; // Audio file
        case 'application/zip':
        case 'application/x-rar-compressed':
            return 'fas fa-file-archive'; // Archive file
        case 'text/html':
        case 'application/javascript':
        case 'application/json':
            return 'fas fa-file-code'; // Code file
        case 'application/java-archive' :
            return 'fab fa-java';
        default:
            return 'fas fa-file'; // Default file icon for unknown types
    }
}



function toggleMetadata(buttonId, metadataDivId) {
    const metadataDiv = document.getElementById(metadataDivId);
    const button = document.getElementById(buttonId);

    // Check if metadata is currently shown
    const isShown = metadataDiv.classList.contains('show');

    // Toggle show class
    if (isShown) {
        metadataDiv.classList.remove('show');
        button.innerText = "Show Metadata";
        metadataDiv.style.display = 'none'; // Optionally, directly manipulate display
    } else {
        // Hide any previously shown metadata divs
        document.querySelectorAll('.file-metadata.show').forEach(div => {
            div.classList.remove('show');
            div.style.display = 'none'; // Hide the div
            // Update the corresponding button text if needed
            const prevButton = document.querySelector(`button[onclick*='${div.id}']`);
            if (prevButton) prevButton.innerText = "Show Metadata";
        });

        metadataDiv.classList.add('show');
        button.innerText = "Hide Metadata";
        metadataDiv.style.display = 'block'; // Optionally, directly manipulate display
    }
}

