<html>
<head>
    <meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
    <title>BD Siestagios - Formador</title></head>
<body background=#ffffff>
<?php include 'style.php'; ?>
<?php include 'db.php'; ?>
<?php $conn = getConn(); ?>
<header style="background:#333; color:#fff; padding:20px;">
    <img src="iscte.png">
    <h1>Portal do Formador</h1>
</header>

<h2>Atribuir notas ao estágio</h2>
<form method="post">
    Empresa ID: <input name="empresa"><br>
    Estabelecimento ID: <input name="estab"><br>
    Aluno ID: <input name="aluno"><br>
    Nota Empresa: <input name="ne"><br>
    Nota Escola: <input name="ns"><br>
    Nota Procura: <input name="np"><br>
    Nota Relatório: <input name="nr"><br>
    <input type="submit" name="avaliar" value="Guardar notas">
</form>

<?php
if (isset($_POST['avaliar'])) {
    $ne = floatval($_POST['ne']);
    $ns = floatval($_POST['ns']);
    $np = floatval($_POST['np']);
    $nr = floatval($_POST['nr']);
    $final = ($ne + $ns + $np + $nr) / 4;

    $stmt = $conn->prepare("UPDATE estagio SET
            nota_empresa = ?,
            nota_escola = ?,
            nota_procura = ?,
            nota_relatorio = ?,
            nota_final = ?,
            data_fim = CURDATE()
            WHERE estabelecimento_empresa_id = ?
            AND estabelecimento_id = ?
            AND aluno_id = ?");
    $stmt->bind_param("ddddddii", $ne, $ns, $np, $nr, $final, $_POST['empresa'], $_POST['estab'], $_POST['aluno']);

    if ($stmt->execute()) echo "Notas registadas. Nota final: $final";
    else echo "Erro: " . $stmt->error;
    $stmt->close();
}
?>
<br><a href="index.php">Voltar ao menu</a>