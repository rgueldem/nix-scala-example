package com.example.nixscalaexample

import cats.effect.{IO, IOApp}

object Main extends IOApp.Simple {
  val run = NixscalaexampleServer.run[IO]
}
