<?php

return new PDO("mysql:host=mysql;dbname=sample", "sampleuser", "samplepass", [PDO::ATTR_PERSISTENT => true]);
