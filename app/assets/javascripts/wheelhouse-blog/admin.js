$(function() {
  function moderate(options) {
    return function() {
      var link = $(this);
      var href = $(this).attr('href');
      
      $.ajax({
        url: href,
        data: options.data,
        type: 'POST',
        success: function(data, status) {
          options.success(link);
        }
      });
      
      Wheelhouse.Flash.loading(options.loading);

      return false;
    };
  }
  
  $(document).on('click', 'a.post-status.pending', moderate({
    data: { approved: 1 },
    loading: "Approving comment...",
    success: function(link) {
      link.removeClass('pending').addClass('approved').text('Approved');
      Wheelhouse.Flash.message("Comment successfully approved.");
    }
  }));
  
  $(document).on('click', 'a.post-status.approved', moderate({
    data: { approved: 0 },
    loading: "Unapproving comment...",
    success: function(link) {
      link.removeClass('approved').addClass('pending').text('Pending');
      Wheelhouse.Flash.message("Comment successfully unapproved.");
    }
  }));
});
