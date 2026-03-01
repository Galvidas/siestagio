<html>
<head>
    <meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
    <title>BD Siestagios - Aluno</title></head>
<body background=#ffffff>
<?php include 'style.php'; ?>
<?php include 'db.php'; ?>
<?php $conn = getConn(); ?>
<header style="background:#333; color:#fff; padding:20px;">
    <img src="iscte.png">
    <h1>Portal do Aluno</h1>
</header>

<h2>Empresas com disponibilidade</h2>
<form method="get">
    Localidade: <input name="localidade">
    <input type="submit" value="Filtrar">
</form>

<?php
if (isset($_GET['localidade']) && $_GET['localidade'] != "") {
    $stmt = $conn->prepare("SELECT firma, tipo_organizacao, localidade, telefone, website FROM empresa WHERE localidade = ?");
    $stmt->bind_param("s", $_GET['localidade']);
    $stmt->execute();
    $res = $stmt->get_result();
    $stmt->close();
} else {
    $res = $conn->query("SELECT firma, tipo_organizacao, localidade, telefone, website FROM empresa");
}

while ($r = $res->fetch_assoc()) {
    $website = $r['website'] ?: '—';
    echo "<b>{$r['firma']}</b> ({$r['tipo_organizacao']}) - {$r['localidade']} | Tel: {$r['telefone']} | Web: $website<br>";
}
?>

<h2>Empresas com disponibilidade para estágios (ano atual)</h2>
<?php
$res = $conn->query("
        SELECT e.empresa_id, e.firma, e.tipo_organizacao, e.localidade, e.telefone, e.website, d.num_estagios
        FROM empresa e
        JOIN disponibilidade d ON d.empresa_id = e.empresa_id
        WHERE d.ano = YEAR(CURDATE())
        AND d.num_estagios > 0
    ");

while ($r = $res->fetch_assoc()) {
    echo "<b>{$r['firma']}</b><br>";
    echo "Tipo de organização: {$r['tipo_organizacao']}<br>";
    echo "Localidade: {$r['localidade']}<br>";
    echo "Telefone: {$r['telefone']}<br>";
    echo "Website: {$r['website']}<br><br>";
}
?>
<br><a href="index.php">Voltar ao menu</a>