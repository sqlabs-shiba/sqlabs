SmartEditorPlugins.contenteditable.push 'gallery'

SmartEditorPlugins.edit_dialog['gallery'] = (@model, @view) =>

  dialog = SmartEditor.utils.dialog 'form_gallery', 
    "<table><tbody>" + 
    "<tr><td class=\"w2p_fw\"><label>effect: </label></td><td><select name=\"effect\"><option value=\"wave\">wave</option><option value=\"zipper\">zipper</option><option value=\"curtain\">curtain</option></select></td>" + 
    "<td class=\"w2p_fw\"><label>width: </label></td><td><input class=\"integer\" name=\"width\" type=\"text\" value=\"\"></td>" + 
    "<td class=\"w2p_fw\"><label>height: </label></td><td><input class=\"integer\" name=\"height\" type=\"text\" value=\"\"></td>" + 
    "<td class=\"w2p_fw\"><label>切替秒数: </label></td><td><input class=\"integer\" name=\"delay\" type=\"text\" value=\"\"></td></tr>" + 
    "</tbody></table>" +
    "<div><a id=\"new_gallery_file\" class=\"btn w2p_trap\" href=\"#\" style=\"float:left;margin-right:20px;\"><span class=\"ui-icon  ui-icon-plusthick\"></span><span class=\"ui-button-text\">画像選択</span></a></div>" +
    "<div style=\"clear:both;\"></div><br/>" +
    "<table class=\"solidtable\" id=\"managed_html__managed_html_image_grid_form_maintable\"><thead>" +
    "<tr><th colspan=\"2\">ファイル</th></tr>" +
    "</tbody></table>" +
    "<table><tbody><tr id=\"submit_record__row\"><td class=\"w2p_fw\"><input type=\"button\" name=\"submit_button\" value=\"登録する\"></td></tr></tbody></table>"
    
  dialog.find('#new_gallery_file').click ->
    new_dialog = SmartEditor.utils.dialog 'managed_html_image_chooser', "loading..." 
    managed_html_ajax_page document.location, {"_action": "image_chooser", "_managed_html_image_grid": 'True',}, 'content_managed_html_image_chooser', ->
      new_dialog.find('.ui-btn[href=#]').attr('onclick', '')
      new_dialog.find('.ui-btn[href=#]').click ->
        dialog.find('.solidtable').append(
          $("<tr>").append(
            $("<td>").append(
              $("<a>").attr({'href':$(this).closest('tr').find('textarea').val(), "target":"_blank"}).append(
                $("<img>").attr({'file_id':$(this).attr('file_id'), 'src':$(this).closest('tr').find('textarea').val(), 'style':'max-width:80px;max-height:80px;'})
              )
            )
          ).append(
            $('<td>').append(
              $('<a>').attr({'class':'ui-btn w2p_trap', 'href':'#'}).append($('<span class="ui-icon ui-icon-close"></span><span class="ui-button-text">削除</span>')).click ->
                $(this).closest('tr').remove()
            )
          )
        )
        new_dialog.remove()
    new_dialog.show()
    
  $(@view.el).find('img[file_id]').each ->
    dialog.find('.solidtable').append(
      $("<tr>").append(
        $("<td>").append(
          $("<a>").attr({'href':$(this).attr('src'), "target":"_blank"}).append(
            $("<img>").attr({'file_id':$(this).attr('file_id'), 'src':$(this).attr('src'), 'style':'max-width:80px;max-height:80px;'})
          )
        )
      ).append(
        $('<td>').append(
          $('<a>').attr({'class':'ui-btn w2p_trap', 'href':'#'}).append($('<span class="ui-icon ui-icon-close"></span><span class="ui-button-text">削除</span>')).click ->
            $(this).closest('tr').remove()
        )
      )
    )
      
  dialog.find('input[name=width]').val($('#no_table_width').val())
  dialog.find('input[name=height]').val($('#no_table_height').val())
  dialog.find('select[name=effect]').val($('#no_table_effect').val())
  dialog.find('input[name=delay]').val($('#no_table_delay').val())
  dialog.find('input[name=submit_button]').bind 'click', (event) =>
    file_ids = ""
    dialog.find('img[file_id]').each ->
      file_ids += $(this).attr('file_id') + ','
    $('#no_table_gallery').val(file_ids.substring(0, file_ids.length-1))
    $('#no_table_width').val(dialog.find('input[name=width]').val())
    $('#no_table_height').val(dialog.find('input[name=height]').val())
    $('#no_table_effect').val(dialog.find('select[name=effect]').val())
    $('#no_table_delay').val(dialog.find('input[name=delay]').val())
    dialog.remove()
    @view.commit()

  dialog.show()
