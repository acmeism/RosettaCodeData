quine=$(info quine=$(value quine))$(info $$(quine))$(eval quine:;@:)
$(quine)
