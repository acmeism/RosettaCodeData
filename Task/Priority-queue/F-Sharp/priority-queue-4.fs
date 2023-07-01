> let testseq = [| (3u, "Clear drains");
                   (4u, "Feed cat");
                   (5u, "Make tea");
                   (1u, "Solve RC tasks");
                   (2u, "Tax return") |] |> Array.toSeq
  let testpq = testseq |> MinHeap.fromSeq
  testseq |> Seq.fold (fun pq (k, v) -> MinHeap.push k v pq) MinHeap.empty
  |> MinHeap.toSeq |> Seq.iter (printfn "%A") // test slow build
  printfn ""
  testseq |> MinHeap.fromSeq |> MinHeap.toSeq // test fast build
   |> Seq.iter (printfn "%A")
  printfn ""
  testseq |> MinHeap.sort |> Seq.iter (printfn "%A") // convenience function
  printfn ""
  MinHeap.merge testpq testpq // test merge
  |> MinHeap.toSeq |> Seq.iter (printfn "%A")
  printfn ""
  testpq |> MinHeap.adjust (fun k v -> uint32 (MinHeap.size testpq) - k, v)
  |> MinHeap.toSeq |> Seq.iter (printfn "%A") // test adjust;;
