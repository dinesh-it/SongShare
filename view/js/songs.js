$(document).ready(function() {
    $(document).ajaxStart(function() {
        $("#wait").css("display", "block");
    });
    $(document).ajaxComplete(function() {
        $("#wait").css("display", "none");
    });

    $.ajax({
        type: "GET",
        url: "/perl/my_ip",
        dataType: "text",
        success: function(data) {
            $('#ip_tag').html("You are accessing from IP: " + data);
        }
    });

    var songs_table = $('#songs').dataTable({
        "sDom": '<"top"if><"table_content"t><"clear">',
        "bPaginate": false,
        "bautoWidth": false,
        "ajax": '/songs_list/Ajith_hits.list',
        "createdRow": function(row, data, index) {
            var url = $('td', row).eq(3).html();
            var play = '<a href="' + url + '" onClick="return false" class="play_song">Play</a>&nbsp;';
            var queue = '<a href="' + url + '" onClick="return false" class="add_song">Queue</a>&nbsp;<br/>';
            var download = '<a href="' + url + '" download>Download</a>';
            $('td', row).eq(3).html(play + queue + download);
        }
    });
    /*.yadcf([{
		column_number: 0, filter_type: "auto_complete"
		}, {
		column_number: 1, filter_type: "auto_complete"
		}, {
		column_number: 2, filter_type: "auto_complete"
		}]);*/

    var folders = "<div id='my_combo'>Choose Folder: <select id='folder'>" +
        "<option value='Ajith_hits'>Ajith hits</option>" +
        "<option value='Arjun_hits'>Arjun hits</option>" +
        "<option value='A_R_Rahman'>A R Rahman</option>" +
        "<option value='collections'>collections</option>" +
        "<option value='Dilip_Varman'>Dilip Varman</option>" +
        "<option value='Film_Wise'>Film Wise</option>" +
        "<option value='Hariharan_hangama'>Hariharan hangama</option>" +
        "<option value='Ilayaraja_Hits'>Ilayaraja Hits</option>" +
        "<option value='Kamal_hits'>Kamal hits</option>" +
        "<option value='2016'>2016</option>" +
        "<option value='2015'>2015</option>" +
        "<option value='2014'>2014</option>" +
        "<option value='Melodious_Love_Songs'>Melodious Love Songs</option>" +
        "<option value='OLd_Melodious'>OLd Melodious</option>" +
        "<option value='Prabudheva_Hits'>Prabudheva Hits</option>" +
        "<option value='P_Suseela'>P Suseela</option>" +
        "<option value='Rajini_Hits'>Rajini Hits</option>" +
        "<option value='Spb_Chitra'>Spb Chitra</option>" +
        "<option value='Spb_Janaki'>Spb Janaki</option>" +
        "<option value='Surya_Hits'>Surya Hits</option>" +
        "<option value='Tamil_Songs'>Tamil Songs</option>" +
        "<option value='un_organized'>un organized</option>" +
        "<option value='Vijay_Hits'>Vijay Hits</option>" +
        "<option value='Yuvan_hits'>Yuvan Hits</option>" +
        "<option value='Yuvan_melodious'>Yuvan Melodious</option>" +
        "<option value='Yuvan_voice'>Yuvan Voice</option>" +
        "<option value='All'>All</option>" +
        "</select> <button id='load-playlist'>Load My Playlist</button> " +
        "<button id='save-playlist'>Save Current Playlist</button> " + 
        "<button id='download-playlist'>Download Current Playlist</button> " +
        "<br/><a href='#' data-column='0' class='toggle-column'>Show Artist</a> " +
        "<a href='#' data-column='1' class='toggle-column'>Show Album</a> " +
		" </div> " +
		"<p id='ip_tag'></p>";

    $(".top").append(folders);

    $('#folder').on('change', function() {
        songs_table.api().ajax.url("/songs_list/" + $(this).val() + ".list").load();
    });


    var myPlaylist = new jPlayerPlaylist({
        jPlayer: "#jquery_jplayer_N",
        cssSelectorAncestor: "#jp_container_N"
    }, [], {
        playlistOptions: {
            enableRemoveControls: true
        },
        swfPath: "/jqp/js",
        supplied: "mp3",
        smoothPlayBar: true,
        keyEnabled: true,
        audioFullScreen: false
    });
    $(document).on("click", ".play_song", function() {
        myPlaylist.option("autoPlay", true);
        myPlaylist.pause();
        var song_info = new Array();
        $.each($(this).parent().parent().children(), function(i, x) {
            if (i != 3) {
                song_info[i] = $(x).html();
            } else {
                song_info[i] = $(x).find('a').attr('href');
            }
        });
        myPlaylist.setPlaylist([{
            title: song_info[2],
            artist: song_info[0],
            album: song_info[1],
            mp3: song_info[3],
        }]);
    });

    $("#clear_playlist").on("click", function() {
        myPlaylist.remove();
    });

    $(document).on("click", ".add_song", function() {
        var song_info = new Array();
        $.each($(this).parent().parent().children(), function(i, x) {
            if (i != 3) {
                song_info[i] = $(x).html();
            } else {
                song_info[i] = $(x).find('a').attr('href');
            }
        });
        myPlaylist.add({
            title: song_info[2],
            artist: song_info[0],
            album: song_info[1],
            mp3: song_info[3],
        });
    });


    $('#add_all_filtered').click(function() {
        $.each($('#songs').find('tbody').children(), function(i, x) {
            $(x).find('.add_song').trigger('click')
        });
    });

    $('#save-playlist').click(function() {
        if (confirm("Are you sure?\nYour Previous playlist will be replaced.")) {
            $.post('/perl/songs/playlist.pl', {
                action: "save",
                data: JSON.stringify(myPlaylist.playlist)
            });
            return true;
        }
        return false;
    });

    $('#load-playlist').click(function() {
        $.ajax({
            type: "GET",
            url: "/perl/songs/playlist.pl?action=load",
            dataType: "text",
            success: function(data) {
				var songs = [];
				songs_table.fnClearTable();
				$.each($.parseJSON(data), function(i,song){
					songs.push([song['artist'],song['album'],song['title'],song['mp3']]);
				});
				songs_table.fnAddData(songs);
                myPlaylist.setPlaylist($.parseJSON(data));
                return true;
            }
        });
    });

	$('#download-playlist').click(function() {
		var songs = myPlaylist.playlist;
		if(songs.length > 50){
			alert("You can download only 50 songs at a time. Requested playlist contains " + songs.length + " files");
			return false;
		}

		$.ajax({ 
			//method: "POST",
			type: "POST",
			url: '/perl/songs/playlist.pl',
			data: {
				action: "prepare",
				data: JSON.stringify(songs),
			},
			success: function(data) {
				alert(data + "Click ok to continue\n");
				window.location = '/perl/songs/playlist.pl?action=download';
			}
		});
	});

	$('a.toggle-column').on( 'click', function (e) {
		e.preventDefault();
		var bVis = songs_table.fnSettings().aoColumns[$(this).attr('data-column')].bVisible;
		songs_table.fnSetColumnVis($(this).attr('data-column'), bVis ? false : true );
	});

});
