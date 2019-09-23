local FluentSyntax = require("fluent.syntax")

describe('fluent.syntax', function ()
  local syntax = FluentSyntax()

  it('should instantiate', function ()
    assert.truthy(syntax:is_a(FluentSyntax))
  end)

  describe('parse', function ()

    it('should be called as a method', function ()
      assert.error(function () syntax.parse() end)
      assert.error(function () syntax.parse("") end)
    end)

    it('should require a string', function ()
      assert.error(function () syntax:parse() end)
      assert.error(function () syntax:parse(false) end)
      assert.error(function () syntax:parse(1) end)
      assert.error(function () syntax:parse({}) end)
    end)

    it('should return an empty AST on no input', function ()
      assert.equals("Resource", syntax:parse(""):is_a().type)
    end)

    it('should handle blank blocks', function ()
      assert.equals(0, #syntax:parse(" "))
      assert.equals(0, #syntax:parse(" \n  \n"))
    end)

    it('should handle a simple entry', function ()
      local foo = syntax:parse("foo = bar")
      assert.equals("Identifier", foo[1].type.type)
      assert.equals("Pattern", foo[1].value.type)
    end)

    it('should handle term entries', function ()
      local baz = syntax:parse("-baz = qux")
      assert.equals("Identifier", baz[1].type.type)
      assert.equals("Pattern", baz[1].value.type)
    end)

    it('should handle a entry with an attribute', function ()
      local foobaz = syntax:parse("foo = bar\n .baz = qux")
      assert.equals("Attribute", foobaz[1][3].type)
      assert.equals("Pattern", foobaz[1][3][2].type)
    end)

    it('should handle complex term entries', function ()
    --   assert.equals("Entry", syntax:parse("foo = türkçe\n görüşürüz")[1].id)
    end)

    it('should handle simple comments', function ()
    --   assert.same("CommentLine", syntax:parse("# foo")[1][1].id)
    --   assert.same("CommentLine", syntax:parse("## foo")[1][1].id)
    --   assert.same("CommentLine", syntax:parse("### foo")[1][1].id)
    end)

    it('should handle junk', function ()
    --   assert.equals("Junk", syntax:parse("foo{")[1].id)
    --   assert.equals("Junk", syntax:parse("ą=b")[1].id)
    --   assert.equals("Junk", syntax:parse("!")[1].id)
    --   assert.equals("Junk", syntax:parse("#foo")[1].id)
    end)

  end)

end)
