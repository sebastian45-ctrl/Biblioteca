<?php
require_once 'db_connection.php';
require_once 'functions.php';

$action = $_POST['action'] ?? $_GET['action'] ?? '';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    if ($action == 'create') {
        createLibro($pdo, [
            'titulo' => $_POST['titulo'],
            'anio' => $_POST['anio'],
            'isbn' => $_POST['isbn'],
            'num_paginas' => $_POST['num_paginas'],
            'id_categoria' => $_POST['id_categoria'],
            'id_editorial' => $_POST['id_editorial']
        ]);
    } elseif ($action == 'update') {
        updateLibro($pdo, [
            'id' => $_POST['id'],
            'titulo' => $_POST['titulo'],
            'anio' => $_POST['anio'],
            'isbn' => $_POST['isbn'],
            'num_paginas' => $_POST['num_paginas'],
            'id_categoria' => $_POST['id_categoria'],
            'id_editorial' => $_POST['id_editorial']
        ]);
    } elseif ($action == 'delete') {
        deleteLibro($pdo, $_POST['id']);
    }
    header('Location: index.php');
    exit;
}

$libros = getLibros($pdo);
$categorias = getCategorias($pdo);
$editoriales = getEditoriales($pdo);

$libro = null;
if ($action == 'edit') {
    $libro = getLibro($pdo, $_GET['id']);
}
?>

<!DOCTYPE html>
<html lang="es">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>CRUD de Libros</title>
  <link rel="stylesheet" href="styles.css">
</head>

<body>
  <h1>Gestión de Libros</h1>

  <h2><?php echo $libro ? 'Editar' : 'Agregar'; ?> Libro</h2>
  <form method="post">
    <input type="hidden" name="action" value="<?php echo $libro ? 'update' : 'create'; ?>">
    <?php if ($libro): ?>
    <input type="hidden" name="id" value="<?php echo $libro['id']; ?>">
    <?php endif; ?>
    <input type="text" name="titulo" placeholder="Título" value="<?php echo $libro['titulo'] ?? ''; ?>" required>
    <input type="number" name="anio" placeholder="Año" value="<?php echo $libro['anio'] ?? ''; ?>" required>
    <input type="text" name="isbn" placeholder="ISBN" value="<?php echo $libro['isbn'] ?? ''; ?>" required>
    <input type="number" name="num_paginas" placeholder="Número de páginas"
      value="<?php echo $libro['num_paginas'] ?? ''; ?>" required>
    <select name="id_categoria" required>
      <option value="">Seleccione una opcion</option>
      <?php foreach ($categorias as $categoria): ?>
      <option value="<?php echo $categoria['id']; ?>"
        <?php echo ($libro['id_categoria'] ?? '') == $categoria['id'] ? 'selected' : ''; ?>>
        <?php echo $categoria['nombre']; ?>
      </option>
      <?php endforeach; ?>
    </select>
    <select name="id_editorial" required>
      <option value="">Seleccione una opcion</option>
      <?php foreach ($editoriales as $editorial): ?> <option value="<?php echo $editorial['id']; ?>"
        <?php echo ($libro['id_editorial'] ?? '') == $editorial['id'] ? 'selected' : ''; ?>>
        <?php echo $editorial['nombre']; ?>
      </option>
      <?php endforeach; ?>
    </select>
    <input type="submit" value="Guardar">
  </form>

  <h2>Lista de Libros</h2>
  <table>
    <tr>
      <th>ID</th>
      <th>Título</th>
      <th>Año</th>
      <th>ISBN</th>
      <th>Páginas</th>
      <th>Categoría</th>
      <th>Editorial</th>
      <th>Acciones</th>
    </tr>
    <?php foreach ($libros as $libro): ?>
    <tr>
      <td><?php echo $libro['id']; ?></td>
      <td><?php echo $libro['titulo']; ?></td>
      <td><?php echo $libro['anio']; ?></td>
      <td><?php echo $libro['isbn']; ?></td>
      <td><?php echo $libro['num_paginas']; ?></td>
      <td><?php echo $libro['categoria']; ?></td>
      <td><?php echo $libro['editorial']; ?></td>
      <td>
        <a href="index.php?action=edit&id=<?php echo $libro['id']; ?>">Editar</a>
        <form method="post" style="display: inline;">
          <input type="hidden" name="action" value="delete">
          <input type="hidden" name="id" value="<?php echo $libro['id']; ?>">
          <input type="submit" value="Eliminar"
            onclick="return confirm('¿Estás seguro de que quieres eliminar este libro?');">
        </form>
      </td>
    </tr>
    <?php endforeach; ?>
  </table>
</body>

</html>