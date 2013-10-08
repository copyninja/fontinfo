from hy.importer import import_file_to_module
from subprocess import CalledProcessError

metadataparser = import_file_to_module("metadataparser",
                                     "metadataparser.hy")


def test_nonexistent_font():
    "test when non existent file is given to function"
    assert not metadataparser.get_font_metadata("nonexistent.otf")
    assert not metadataparser.get_font_supported_langs("nonexistent.otf")


def test_invalid_font():
    "Pass invalid otf file"
    def _invalid_font_metadata():
        try:
            return metadataparser.get_font_metadata(
                "./tests/resources/notavalidotf.ttf")
        except CalledProcessError:
            return "Error"

    def _invalid_font_supported_langs():
        try:
            return metadataparser.get_font_supported_langs(
                "./tests/resources/notavalidotf.ttf")
        except CalledProcessError:
            return "Error"

    assert _invalid_font_metadata() == "Error"
    assert _invalid_font_supported_langs() == "Error"


def test_fontmetadata():
    "test font metadata extraction"
    import json

    preextracted_dict = None
    with open("./tests/resources/dejavu-sans-boldoblique.dict", "r") as fd:
        preextracted_dict = json.loads(fd.read())

    assert metadataparser.get_font_metadata(
        "./tests/resources/DejaVuSans-BoldOblique.ttf") == preextracted_dict


def test_fontsupportedlangs():
    "test supported language extraction"
    import json

    preextracted_dict = None
    with open("./tests/resources/dejavu-sans-boldoblique_langs.dict",
              "r") as fd:
        preextracted_dict = json.loads(fd.read())

    assert metadataparser.get_font_supported_langs(
        "./tests/resources/DejaVuSans-BoldOblique.ttf") == preextracted_dict


def test_fontinfo():
    "test entire fontinfo generation"
    import json

    preextracted_dict = None
    with open("./tests/resources/Gubbi.dict", "r") as fd:
        preextracted_dict = json.loads(fd.read())

    assert metadataparser.get_font_info(
        "./tests/resources/Gubbi.ttf") == preextracted_dict
