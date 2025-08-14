package day24

import scala.io.Source


val conns = Source.stdin.getLines().toSeq.flatMap { case s"$i/$j" => Seq((i.toInt, j.toInt), (j.toInt, i.toInt)) }.groupMap(_._1)(_._2)

def rec1(from: Int, visited: Set[(Int, Int)]): Int = {
  conns.getOrElse(from, Seq())
    .filter(to => !visited.contains((from, to)) && !visited.contains((to, from)))
    .map(to => from + to + rec1(to, visited + ((from, to))))
    .maxOption.getOrElse(0)
}

def rec2(from: Int, visited: Set[(Int, Int)]): (Int, Int) = {
  conns.getOrElse(from, Seq())
    .filter(to => !visited.contains((from, to)) && !visited.contains((to, from)))
    .map{ to =>
      val (len, power) = rec2(to, visited + ((from, to)))  
      (len + 1, power + to + from)
    }
    .maxOption.getOrElse((0, 0))
}

@main def main(): Unit = {
  val p1 = rec1(0, Set.empty)
  println(s"$p1")

  val p2 = rec2(0, Set.empty)._2
  println(s"$p2")
}

