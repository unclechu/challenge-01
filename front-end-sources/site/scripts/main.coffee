do ($=window.jQuery) ->
	$ ->
		$body = $ 'body'

		# responsive
		$('.catalog-category-elements .column.grid').each ->
			$el = $ @
			$(window).resize ->
				cls = if $body.width() < 800 then 'three' else 'four'
				cls = if $body.width() < 600 then 'two' else cls
				cls = if $body.width() < 420 then 'one' else cls
				$el.attr class: $el.attr('class').replace /(one|two|three|four)/g, cls
		$(window).trigger 'resize'
