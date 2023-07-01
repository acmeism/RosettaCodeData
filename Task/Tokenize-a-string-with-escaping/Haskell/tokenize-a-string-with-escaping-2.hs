{-#Language LambdaCase #-}
import Conduit

splitEscC :: (Monad m, Eq t) => t -> t -> Conduit t m [t]
splitEscC sep esc = mapOutput reverse $ go True []
  where
    go notEsc b = await >>= \case
      Nothing -> yield b
      Just ch | notEsc && ch == esc -> go False b
              | notEsc && ch == sep -> yield b >> go True []
              | otherwise -> go True (ch:b)
