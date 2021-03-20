// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library AsciiPunkFactory {
    function draw(uint256 seed) public pure returns (string memory) {
        uint256 rand = uint256(keccak256(abi.encodePacked(seed)));

        string memory top = _chooseTop(rand);
        string memory eyes = _chooseEyes(rand);
        string memory mouth = _chooseMouth(rand);

        string memory chin = unicode"   │    │   \n" unicode"   └──┘ │   \n";
        string memory neck = unicode"     │  │   \n" unicode"     │  │   \n";

        return string(abi.encodePacked(top, eyes, mouth, chin, neck));
    }

    function _chooseTop(uint256 rand) internal pure returns (string memory) {
        string[56] memory tops =
            [
                unicode"   ┌───┐    \n"
                unicode"   │   ┼┐   \n"
                unicode"   ├────┼┼  \n",
                unicode"   ┌┬┬┬┬┐   \n"
                unicode"   ╓┬┬┬┬╖   \n"
                unicode"   ╙┴┴┴┴╜   \n",
                unicode"   ╒════╕   \n"
                unicode"  ┌┴────┴┐  \n"
                unicode"  └┬────┬┘  \n",
                unicode"   ╒════╕   \n"
                unicode"   │□□□□│   \n"
                unicode"  └┬────┬┘  \n",
                unicode"   ╒════╕   \n"
                unicode"   │    │   \n"
                unicode" └─┬────┬─┘ \n",
                unicode"    ◛◛◛◛    \n"
                unicode"   ▄████▄   \n"
                unicode"   ┌────┐   \n",
                unicode"    ◙◙◙◙    \n"
                unicode"   ▄████▄   \n"
                unicode"   ┌────┐   \n",
                unicode"   ┌───┐    \n"
                unicode"┌──┤   └┐   \n"
                unicode"└──┼────┤   \n",
                unicode"    ┌───┐   \n"
                unicode"   ┌┘   ├──┐\n"
                unicode"   ├────┼──┘\n",
                unicode"   ┌────┐/  \n"
                unicode"┌──┴────┴──┐\n"
                unicode"└──┬────┬──┘\n",
                unicode"   ╒════╕   \n"
                unicode" ┌─┴────┴─┐ \n"
                unicode" └─┬────┬─┘ \n",
                unicode"  ┌──────┐  \n"
                unicode"  │▲▲▲▲▲▲│  \n"
                unicode"  └┬────┬┘  \n",
                unicode"  ┌┌────┐┐  \n"
                unicode"  ││┌──┐││  \n"
                unicode"  └┼┴──┴┼┘  \n",
                unicode"   ┌────┐   \n"
                unicode"  ┌┘─   │   \n"
                unicode"  └┌────┐   \n",
                unicode"            \n"
                unicode"   ┌┬┬┬┬┐   \n"
                unicode"   ├┴┴┴┴┤   \n",
                unicode"            \n"
                unicode"    ╓┬╥┐    \n"
                unicode"   ┌╨┴╨┴┐   \n",
                unicode"            \n"
                unicode"   ╒╦╦╦╦╕   \n"
                unicode"   ╞╩╩╩╩╡   \n",
                unicode"            \n"
                unicode"            \n"
                unicode"   ┌┼┼┼┼┐   \n",
                unicode"            \n"
                unicode"    ││││    \n"
                unicode"   ┌┼┼┼┼┐   \n",
                unicode"      ╔     \n"
                unicode"     ╔║     \n"
                unicode"   ┌─╫╫─┐   \n",
                unicode"            \n"
                unicode"    ║║║║    \n"
                unicode"   ┌╨╨╨╨┐   \n",
                unicode"            \n"
                unicode"   ▐▐▐▌▌▌   \n"
                unicode"   ┌────┐   \n",
                unicode"            \n"
                unicode"   \\/////   \n"
                unicode"   ┌────┐   \n",
                unicode"    ┐ ┌     \n"
                unicode"   ┐││││┌   \n"
                unicode"   ┌────┐   \n",
                unicode"  ┌┐ ┐┌┐┌┐  \n"
                unicode"  └└┐││┌┘   \n"
                unicode"   ┌┴┴┴┴┐   \n",
                unicode"  ┐┐┐┐┐     \n"
                unicode"  └└└└└┐    \n"
                unicode"   └└└└└┐   \n",
                unicode"            \n"
                unicode"   ││││││   \n"
                unicode"   ┌────┐   \n",
                unicode"            \n"
                unicode"    ╓╓╓╓    \n"
                unicode"   ┌╨╨╨╨┐   \n",
                unicode"    ╔╔╗╗╗   \n"
                unicode"   ╔╔╔╗╗╗╗  \n"
                unicode"  ╔╝╝║ ╚╚╗  \n",
                unicode"   ╔╔╔╔╔╗   \n"
                unicode"  ╔╔╔╔╔╗║╗  \n"
                unicode"  ╝║╨╨╨╨║╚  \n",
                unicode"   ╔╔═╔═╔   \n"
                unicode"   ╔╩╔╩╔╝   \n"
                unicode"   ┌────┐   \n",
                unicode"            \n"
                unicode"     ///    \n"
                unicode"   ┌────┐   \n",
                unicode"     ╔╗╔╗   \n"
                unicode"    ╔╗╔╗╝   \n"
                unicode"   ┌╔╝╔╝┐   \n",
                unicode"     ╔╔╔╔╝  \n"
                unicode"    ╔╝╔╝    \n"
                unicode"   ┌╨╨╨─┐   \n",
                unicode"       ╔╗   \n"
                unicode"    ╔╔╔╗╝   \n"
                unicode"   ┌╚╚╝╝┐   \n",
                unicode"   ╔════╗   \n"
                unicode"  ╔╚╚╚╝╝╝╗  \n"
                unicode"  ╟┌────┐╢  \n",
                unicode"    ╔═╗     \n"
                unicode"    ╚╚╚╗    \n"
                unicode"   ┌────┐   \n",
                unicode"            \n"
                unicode"            \n"
                unicode"   ┌╨╨╨╨┐   \n",
                unicode"            \n"
                unicode"    ⌂⌂⌂⌂    \n"
                unicode"   ┌────┐   \n",
                unicode"   ┌────┐   \n"
                unicode"   │   /└┐  \n"
                unicode"   ├────┐/  \n",
                unicode"            \n"
                unicode"   ((((((   \n"
                unicode"   ┌────┐   \n",
                unicode"   ┌┌┌┌┌┐   \n"
                unicode"   ├┘┘┘┘┘   \n"
                unicode"   ┌────┐   \n",
                unicode"   «°┐      \n"
                unicode"    │╪╕     \n"
                unicode"   ┌└┼──┐   \n",
                unicode"  <° °>   § \n"
                unicode"   \\'/   /  \n"
                unicode"   {())}}   \n",
                unicode"   ██████   \n"
                unicode"  ██ ██ ██  \n"
                unicode" █ ██████ █ \n",
                unicode"    ████    \n"
                unicode"   ██◙◙██   \n"
                unicode"   ┌─▼▼─┐   \n",
                unicode"   ╓╖  ╓╖   \n"
                unicode"  °╜╚╗╔╝╙°  \n"
                unicode"   ┌─╨╨─┐   \n",
                unicode"   ± ±± ±   \n"
                unicode"   ◙◙◙◙◙◙   \n"
                unicode"   ┌────┐   \n",
                unicode"  ♫     ♪   \n"
                unicode"    ♪     ♫ \n"
                unicode" ♪ ┌────┐   \n",
                unicode"    /≡≡\\    \n"
                unicode"   /≡≡≡≡\\   \n"
                unicode"  /┌────┐\\  \n",
                unicode"            \n"
                unicode"   ♣♥♦♠♣♥   \n"
                unicode"   ┌────┐   \n",
                unicode"     [⌂]    \n"
                unicode"      │     \n"
                unicode"   ┌────┐   \n",
                unicode"  /\\/\\/\\/\\  \n"
                unicode"  \\\\/\\/\\//  \n"
                unicode"   ┌────┐   \n",
                unicode"    ↑↑↓↓    \n"
                unicode"   ←→←→AB   \n"
                unicode"   ┌────┐   \n",
                unicode"    ┌─┬┐    \n"
                unicode"   ┌┘┌┘└┐   \n"
                unicode"   ├─┴──┤   \n",
                unicode"    ☼  ☼    \n"
                unicode"     \\/     \n"
                unicode"   ┌────┐   \n"
            ];
        uint256 topId = rand % 56;
        return tops[topId];
    }

    function _chooseEyes(uint256 rand) internal pure returns (string memory) {
        string[48] memory leftEyes =
            [
                unicode"◕",
                unicode"ಥ",
                unicode"♥",
                unicode"X",
                unicode"⊙",
                unicode"˘",
                unicode"ಠ",
                unicode"◉",
                unicode"⚆",
                unicode"¬",
                unicode"^",
                unicode"═",
                unicode"┼",
                unicode"┬",
                unicode"■",
                unicode"─",
                unicode"û",
                unicode"╜",
                unicode"δ",
                unicode"│",
                unicode"┐",
                unicode"┌",
                unicode"┌",
                unicode"╤",
                unicode"/",
                unicode"\\",
                unicode"/",
                unicode"\\",
                unicode"╦",
                unicode"♥",
                unicode"♠",
                unicode"♦",
                unicode"╝",
                unicode"◄",
                unicode"►",
                unicode"◄",
                unicode"►",
                unicode"I",
                unicode"╚",
                unicode"╔",
                unicode"╙",
                unicode"╜",
                unicode"╓",
                unicode"╥",
                unicode"$",
                unicode"○",
                unicode"N",
                unicode"x"
            ];

        string[48] memory rightEyes =
            [
                unicode"◕",
                unicode"ಥ",
                unicode"♥",
                unicode"X",
                unicode"⊙",
                unicode"˘",
                unicode"ಠ",
                unicode"◉",
                unicode"⚆",
                unicode"¬",
                unicode"^",
                unicode"═",
                unicode"┼",
                unicode"┬",
                unicode"■",
                unicode"─",
                unicode"û",
                unicode"╜",
                unicode"δ",
                unicode"│",
                unicode"┐",
                unicode"┐",
                unicode"┌",
                unicode"╤",
                unicode"\\",
                unicode"/",
                unicode"/",
                unicode"\\",
                unicode"╦",
                unicode"♠",
                unicode"♣",
                unicode"♦",
                unicode"╝",
                unicode"►",
                unicode"◄",
                unicode"◄",
                unicode"◄",
                unicode"I",
                unicode"╚",
                unicode"╗",
                unicode"╜",
                unicode"╜",
                unicode"╓",
                unicode"╥",
                unicode"$",
                unicode"○",
                unicode"N",
                unicode"x"
            ];
        uint256 eyeId = rand % 48;

        string memory leftEye = leftEyes[eyeId];
        string memory rightEye = rightEyes[eyeId];
        string memory nose = _chooseNose(rand);

        string memory forehead = unicode"   │    ├┐  \n";
        string memory leftFace = unicode"   │";
        string memory rightFace = unicode" └│  \n";

        return
            string(
                abi.encodePacked(
                    forehead,
                    leftFace,
                    leftEye,
                    " ",
                    rightEye,
                    rightFace,
                    nose
                )
            );
    }

    function _chooseMouth(uint256 rand) internal pure returns (string memory) {
        string[32] memory mouths =
            [
                unicode"   │    │   \n"
                unicode"   │──  │   \n",
                unicode"   │    │   \n"
                unicode"   │δ   │   \n",
                unicode"   │    │   \n"
                unicode"   │─┬  │   \n",
                unicode"   │    │   \n"
                unicode"   │(─) │   \n",
                unicode"   │    │   \n"
                unicode"   │[─] │   \n",
                unicode"   │    │   \n"
                unicode"   │<─> │   \n",
                unicode"   │    │   \n"
                unicode"   │╙─  │   \n",
                unicode"   │    │   \n"
                unicode"   │─╜  │   \n",
                unicode"   │    │   \n"
                unicode"   │└─┘ │   \n",
                unicode"   │    │   \n"
                unicode"   │┌─┐ │   \n",
                unicode"   │    │   \n"
                unicode"   │╓─  │   \n",
                unicode"   │    │   \n"
                unicode"   │─╖  │   \n",
                unicode"   │    │   \n"
                unicode"   │┼─┼ │   \n",
                unicode"   │    │   \n"
                unicode"   │──┼ │   \n",
                unicode"   │    │   \n"
                unicode"   │«─» │   \n",
                unicode"   │    │   \n"
                unicode"   │──  │   \n",
                unicode" ∙ │    │   \n"
                unicode" ∙───   │   \n",
                unicode" ∙ │    │   \n"
                unicode" ∙───)  │   \n",
                unicode" ∙ │    │   \n"
                unicode" ∙───]  │   \n",
                unicode"   │⌐¬  │   \n"
                unicode" √────  │   \n",
                unicode"   │╓╖  │   \n"
                unicode"   │──  │   \n",
                unicode"   │~~  │   \n"
                unicode"   │/\\  │   \n",
                unicode"   │    │   \n"
                unicode"   │══  │   \n",
                unicode"   │    │   \n"
                unicode"   │▼▼  │   \n",
                unicode"   │⌐¬  │   \n"
                unicode"   │O   │   \n",
                unicode"   │    │   \n"
                unicode"   │O   │   \n",
                unicode" ∙ │⌐¬  │   \n"
                unicode" ∙───   │   \n",
                unicode" ∙ │⌐¬  │   \n"
                unicode" ∙───)  │   \n",
                unicode" ∙ │⌐¬  │   \n"
                unicode" ∙───]  │   \n",
                unicode"   │⌐¬  │   \n"
                unicode"   │──  │   \n",
                unicode"   │⌐-¬ │   \n"
                unicode"   │    │   \n",
                unicode"   │┌-┐ │   \n"
                unicode"   ││ │ │   \n"
            ];

        uint256 mouthId = rand % 32;

        return mouths[mouthId];
    }

    function _chooseNose(uint256 rand) internal pure returns (string memory) {
        string[9] memory noses =
            [
                unicode"└",
                unicode"╘",
                unicode"<",
                unicode"└",
                unicode"┌",
                unicode"^",
                unicode"└",
                unicode"┼",
                unicode"Γ"
            ];

        uint256 noseId = rand % 9;
        string memory nose = noses[noseId];
        return
            string(abi.encodePacked(unicode"   │ ", nose, unicode"  └┘  \n"));
    }
}
