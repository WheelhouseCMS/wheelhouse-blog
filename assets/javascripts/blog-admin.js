(function() {

var Blog = {
  autofill: function() {
    var title = $('#post_title');
    var permalink = $('#post_permalink');
    
    var customPermalink = false;
    
    title.input(function() {
      if (!customPermalink) {
        var slug = Wheelhouse.Form.slugify($(this).val());
        permalink.val(slug);
      }
    });
    
    permalink.input(function() { customPermalink = true; });
  },
  
  setupCategories: function() {
    var list = $('#blog-categories');
    
    var newCategory = $('<input type="text" placeholder="Add a category..." />');
    
    newCategory.blur(function() {
      var name = newCategory.val();
      
      if (name != '' && name != newCategory.attr('placeholder')) {
        var label = $('<label />');
      
        $('<input type="checkbox" />')
          .val(name)
          .attr('name', 'post[categories][]')
          .attr('checked', 'checked')
          .appendTo(label);

        label.append(' ' + name);
      
        $('<li />').append(label).insertBefore(newCategory.parent());
        newCategory.val('');
      }
    });
    
    newCategory.keypress(function(e) {
      // Tab/enter key pressed
      if (e.keyCode == '9' || e.keyCode == '13') {
        e.preventDefault();
        
        if (newCategory.val() != '' && newCategory.val() != newCategory.attr('placeholder')) {
          newCategory.blur().focus().select();
        }
      }
    });
    
    $('<li />').addClass('new').append(newCategory).appendTo(list);
    
    newCategory.placeholder();
  }
};

window.Blog = Blog;

})();
