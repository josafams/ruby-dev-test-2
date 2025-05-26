require 'test_helper'

class AlbumPlayerTest < ActiveSupport::TestCase
  test 'valid album_player' do
    album_player = AlbumPlayer.new(album: albums(:fixation), player: players(:beyonce))
    assert album_player.valid?
  end

  test 'presence of album' do
    album_player = AlbumPlayer.new(player: players(:shakira))
    assert_not album_player.valid?
    assert_not_empty album_player.errors[:album]
  end

  test 'presence of player' do
    album_player = AlbumPlayer.new(album: albums(:fijacion))
    assert_not album_player.valid?
    assert_not_empty album_player.errors[:player]
  end

  test 'uniqueness of album and player combination' do
    existing_combination = album_players(:fijacion_shakira)

    duplicate = AlbumPlayer.new(album: existing_combination.album, player: existing_combination.player)
    assert_not duplicate.valid?
    assert_not_empty duplicate.errors[:album_id]
  end

  test 'same album can have multiple players' do
    album = albums(:fijacion)

    existing_album_player = album_players(:fijacion_shakira)
    album_player2 = AlbumPlayer.new(album: album, player: players(:beyonce))

    assert album_player2.valid?
  end

  test 'same player can have multiple albums' do
    player = players(:beyonce)

    album_player1 = AlbumPlayer.create!(album: albums(:fijacion), player: player)
    album_player2 = AlbumPlayer.new(album: albums(:fixation), player: player)

    assert album_player2.valid?
  end
end
