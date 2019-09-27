-- Internal modules
local FluentSyntax = require("fluent.syntax")

describe('fluent.syntax', function ()
  local syntax = FluentSyntax()

  it('should be independently instantiatable', function ()
    assert.is_true(syntax:is_a(FluentSyntax))
  end)

  describe('parsestring', function ()

    it('should be called as a method', function ()
      assert.error(function () syntax.parsestring() end)
      assert.error(function () syntax.parsestring("") end)
    end)

    it('should require a string', function ()
      assert.error(function () syntax:parsestring() end)
      assert.error(function () syntax:parsestring(false) end)
      assert.error(function () syntax:parsestring(1) end)
      assert.error(function () syntax:parsestring({}) end)
    end)

    it('should return an empty AST on no input', function ()
      assert.equals("Resource", syntax:parsestring("").type)
    end)

    it('should handle blank blocks', function ()
      assert.equals(0, #syntax:parsestring(" "))
      assert.equals(0, #syntax:parsestring(" \n  \n"))
    end)

    it('should handle a simple entry', function ()
      local foo = syntax:parsestring("foo = bar")
      assert.equals("Identifier", foo.body[1].id.type)
      assert.equals("Pattern", foo.body[1].value.type)
    end)

    it('should handle term entries', function ()
      local baz = syntax:parsestring("-baz = qux")
      assert.equals("Identifier", baz.body[1].id.type)
      assert.equals("Pattern", baz.body[1].value.type)
    end)

    it('should handle a entry with an attribute', function ()
      local foobaz = syntax:parsestring("foo = bar\n .baz = qux")
      -- assert.equals("Attribute", foobaz.body[1].attributes[1].type)
      assert.equals("Pattern", foobaz.body[1].value.type)
    end)

    it('should handle multiline entries', function ()
      local foo = syntax:parsestring("foo = türkçe\n görüşürüz")
      assert.equals("Pattern", foo.body[1].value.type)
    end)

    it('should handle literal string placables', function ()
      local foo = syntax:parsestring('foo = bar {"baz"}')
      assert.equals(2, #foo.body[1].value.elements)
      assert.equals("TextElement", foo.body[1].value.elements[1].type)
      assert.equals("StringLiteral", foo.body[1].value.elements[2].expression.type)
    end)

    it('should handle literal number placables', function ()
      local foo = syntax:parsestring('foo = bar {-54.3}')
      assert.equals(2, #foo.body[1].value.elements)
      assert.equals("TextElement", foo.body[1].value.elements[1].type)
      assert.equals("NumberLiteral", foo.body[1].value.elements[2].expression.type)
    end)

    it('should handle literal variable reference placables', function ()
      local foo = syntax:parsestring('foo = bar { $baz }')
      assert.equals(2, #foo.body[1].value.elements)
      assert.equals("TextElement", foo.body[1].value.elements[1].type)
      assert.equals("VariableReference", foo.body[1].value.elements[2].expression.type)
    end)

    it('should handle message plus attributes', function ()
      local foo = syntax:parsestring('foo = bar\n    .baz = qux')
      assert.equals(1, #foo.body[1].value.elements)
      assert.equals(1, #foo.body[1].attributes)
      assert.equals("TextElement", foo.body[1].value.elements[1].type)
      assert.equals("TextElement", foo.body[1].attributes[1].value.elements[1].type)
    end)

    it('should handle just attributes', function ()
      local foo = syntax:parsestring('foo =\n    .baz = qux')
      assert.equals("nil", type(foo.body[1].value))
      assert.equals(1, #foo.body[1].attributes)
      assert.equals("TextElement", foo.body[1].attributes[1].value.elements[1].type)
    end)

    it('should handle simple comments', function ()
      assert.equals("Comment", syntax:parsestring("# foo").body[1].type)
      assert.equals("GroupComment", syntax:parsestring("## foo").body[1].type)
      assert.equals("ResourceComment", syntax:parsestring("### foo").body[1].type)
    end)

    it('should handle junk', function ()
      assert.equals("Junk", syntax:parsestring("foo{").body[1].type)
      assert.equals("Junk", syntax:parsestring("ą=b").body[1].type)
      assert.equals("Junk", syntax:parsestring("!").body[1].type)
      assert.equals("Junk", syntax:parsestring("#foo").body[1].type)
    end)

  end)

end)
