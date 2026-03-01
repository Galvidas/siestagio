<?php
$conn = new mysqli("localhost", "root", "", "siestagio");
if ($conn->connect_error) {
  die("Erro de ligação à BD");
}

function removerEstagio($conn, $aluno_id) {
    $stmt = $conn->prepare("DELETE FROM `estagio` WHERE `aluno_id` = ?");
    $stmt->bind_param("i", $aluno_id);
    $stmt->execute();
    $stmt->close();
}

function getConn() {
    $conn = new mysqli("localhost", "root", "", "siestagio");
    if ($conn->connect_error) {
        die("Erro de ligação à BD");
    }
    return $conn;
}

?>
