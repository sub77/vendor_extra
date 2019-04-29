<?php
function list_files($path) {
    $output = array();
    $files = scandir($path);
    if ($path == "./_h5ai" || $path == "./.bak" || $path=="./.sync" || $path=="./Modem" || $path=="./Delta") return $output;

    foreach ($files as $file) {
        if ($file == "." || $file == ".." || strpos($file, '.html')
            || $file == ".bak" || $file == "_h5ai") {
            continue;
        }

        if (is_dir($path.'/'.$file)) {
            $output[$path.'/'.$file] = list_files($path.'/'.$file);
        } else {
            $output[] = array("filename"=>$path.'/'.$file, "timestamp"=>filemtime($path.'/'.$file));
        }
    }

    return $output;
}

echo json_encode(list_files("."));
?>

