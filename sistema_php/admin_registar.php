<html>
<head>
    <meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
    <title>BD Siestagios - Administrador</title></head>
<body background=#ffffff>
<?php include 'style.php'; ?>
<?php include 'db.php'; ?>
<?php $conn = getConn(); ?>
<header style="background:#333; color:#fff; padding:20px;">
    <img src="iscte.png">
    <h1>Portal do Administrador</h1>
</header>

<h2>Registar novo aluno</h2>
<form method="post">
    Turma ID: <input name="turma"><br>
    Utilizador ID: <input name="utilizador"><br>
    Número: <input name="numero"><br>
    <input type="submit" name="registar_aln" value="Registar">
    <input type="reset" name="Submit2" value="Limpar">
</form>

<h3>Registar novo estágio</h3>
<form method="post">
    Empresa ID: <input name="empresa"><br>
    Estabelecimento ID: <input name="estab"><br>
    Aluno ID: <input name="aluno"><br>
    Formador ID: <input name="formador"><br>
    Data Início: <input type="date" name="inicio"><br>
    <input type="submit" name="registar_est" value="Registar">
    <input type="reset" name="Submit2" value="Limpar">
</form>

<?php
// Register new student
if (isset($_POST['registar_aln'])) {
    $stmt = $conn->prepare("INSERT INTO `aluno` (`turma_id`, `utilizador_id`, `numero`, `observacoes`) VALUES (?, ?, ?, NULL)");
    $stmt->bind_param("iii", $_POST['turma'], $_POST['utilizador'], $_POST['numero']);
    if ($stmt->execute()) echo "Aluno registado com sucesso<br>";
    else echo "Erro: " . $stmt->error;
    $stmt->close();
}

// Register new internship using stored procedure
if (isset($_POST['registar_est'])) {
    $stmt = $conn->prepare("CALL P1(?, ?, ?, ?, ?, @p_resultado)");
    $stmt->bind_param("iiiis", $_POST['empresa'], $_POST['estab'], $_POST['aluno'], $_POST['formador'], $_POST['inicio']);
    if ($stmt->execute()) {
        $res = $conn->query("SELECT @p_resultado AS resultado");
        $row = $res->fetch_assoc();
        echo $row['resultado'];
    } else {
        echo "Erro: " . $stmt->error;
    }
    $stmt->close();
}
?>

<h3>Listagem de Estágios</h3>
<?php
$res = $conn->query("SELECT * FROM estagio ORDER BY aluno_id ASC");
while ($r = $res->fetch_assoc()) {
    echo "Aluno {$r['aluno_id']} | {$r['data_inicio']}";
    if (!is_null($r['data_fim'])) {
        echo " → {$r['data_fim']}";
    } else {
        echo '<a href="?ato=remover&aluno_id=' . intval($r['aluno_id']) . '"> Remover</a>';
    }
    echo "<br>";
}

if (isset($_GET["ato"], $_GET["aluno_id"])) {
    if ($_GET["ato"] === "remover") {
        removerEstagio($conn, intval($_GET["aluno_id"]));
        header("Location: " . $_SERVER['PHP_SELF']);
        exit;
    }
}
?>
<br><a href="index.php">Voltar ao menu</a>