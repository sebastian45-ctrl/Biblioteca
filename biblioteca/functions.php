<?php
function getLibros($pdo) {
    $stmt = $pdo->query("SELECT l.*, c.nombre as categoria, e.nombre as editorial 
                         FROM Libro l 
                         JOIN categoria c ON l.id_categoria = c.id 
                         JOIN editorial e ON l.id_editorial = e.id");
    return $stmt->fetchAll(PDO::FETCH_ASSOC);
}

function getLibro($pdo, $id) {
    $stmt = $pdo->prepare("SELECT * FROM Libro WHERE id = ?");
    $stmt->execute([$id]);
    return $stmt->fetch(PDO::FETCH_ASSOC);
}

function getCategorias($pdo) {
    $stmt = $pdo->query("SELECT * FROM categoria");
    return $stmt->fetchAll(PDO::FETCH_ASSOC);
}

function getEditoriales($pdo) {
    $stmt = $pdo->query("SELECT * FROM editorial");
    return $stmt->fetchAll(PDO::FETCH_ASSOC);
}

function createLibro($pdo, $data) {
    $sql = "INSERT INTO Libro (titulo, anio, isbn, num_paginas, id_categoria, id_editorial) 
            VALUES (:titulo, :anio, :isbn, :num_paginas, :id_categoria, :id_editorial)";
    $stmt = $pdo->prepare($sql);
    $stmt->execute($data);
}

function updateLibro($pdo, $data) {
    $sql = "UPDATE Libro SET titulo = :titulo, anio = :anio, isbn = :isbn, 
            num_paginas = :num_paginas, id_categoria = :id_categoria, id_editorial = :id_editorial 
            WHERE id = :id";
    $stmt = $pdo->prepare($sql);
    $stmt->execute($data);
}

function deleteLibro($pdo, $id) {
    $sql = "DELETE FROM Libro WHERE id = :id";
    $stmt = $pdo->prepare($sql);
    $stmt->execute(['id' => $id]);
}
?>