<?php



function uploadFiles($files)
{
    try {
        // echo json_encode($_POST['images']);
        $uploadedFiles = array();
        $errors = array();
        $allowedExtensions = array('jpg', 'jpeg', 'png', 'gif');
        $uploadPath = './uploads/';


        foreach ($files['name'] as $key => $fileName) {
            $fileTmp = $files['tmp_name'][$key];
            $fileSize = $files['size'][$key];
            $fileError = $files['error'][$key];
            $fileExtension = pathinfo($fileName, PATHINFO_EXTENSION);
            echo '<br>';
            echo json_encode('fileExtension: ' . $fileExtension);
            echo '<br>';

            if (in_array($fileExtension, $allowedExtensions)) {
                if ($fileError === 0) {
                    if ($fileSize <= 1000000) {
                        $fileNewName = uniqid('', true) . '.' . $fileExtension;
                        $fileDestination = $uploadPath . $fileNewName;

                        echo '<br>';
                        echo json_encode('fileDestination: ' . $fileDestination);
                        echo '<br>';

                        if (move_uploaded_file($fileTmp, $fileDestination)) {
                            $uploadedFiles[] = $fileDestination;
                        } else {
                            $errors[] = "Error uploadings $fileName. Please try again.";
                        }
                    } else {
                        $errors[] = "$fileName is too large. Max size is 1MB.";
                    }
                } else {
                    $errors[] = "Error uploading $fileName. Please try again.";
                }
            } else {
                $errors[] = "$fileName is not a valid file type.";
            }
        }

        return array(
            'uploadedFiles' => $uploadedFiles,
            'errors' => $errors
        );
    } catch (Exception $e) {
        echo json_encode($e->getMessage());
    }
}



if (isset($_POST['submit'])) {

    try {

        $files = $_FILES['images'];

        echo json_encode($files);

        $uploadResults = uploadFiles($files);

        $uploadedFiles = $uploadResults['uploadedFiles'];
        $errors = $uploadResults['errors'];

        // echo json_encode($uploadedFiles);

        if (!empty($uploadedFiles)) {
            echo json_encode('<h3>Uploaded Files:</h3>');
            foreach ($uploadedFiles as $file) {
                echo json_encode("<p>$file</p>");
            }
        }

        if (!empty($errors)) {
            echo '<h3>Errors:</h3>';
            foreach ($errors as $error) {
                echo json_encode("<p>$error</p>");
            }
        }
    } catch (Exception $e) {
        echo json_encode($e->getMessage());
    }
}
