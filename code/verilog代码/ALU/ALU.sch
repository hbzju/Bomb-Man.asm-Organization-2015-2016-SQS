<?xml version="1.0" encoding="UTF-8"?>
<drawing version="7">
    <attr value="kintex7" name="DeviceFamilyName">
        <trait delete="all:0" />
        <trait editname="all:0" />
        <trait edittrait="all:0" />
    </attr>
    <netlist>
        <signal name="ALU_operation(2:0)" />
        <signal name="XLXN_3(31:0)" />
        <signal name="A(31:0)" />
        <signal name="B(31:0)" />
        <signal name="S(32:0)" />
        <signal name="S(31:0)" />
        <signal name="ALU_operation(2)" />
        <signal name="XLXN_13(31:0)" />
        <signal name="XLXN_15(31:0)" />
        <signal name="XLXN_16(31:0)" />
        <signal name="XLXN_17(31:0)" />
        <signal name="XLXN_18(31:0)" />
        <signal name="N0,N0,N0,N0,N0,N0,N0,N0,N0,N0,N0,N0,N0,N0,N0,N0,N0,N0,N0,N0,N0,N0,N0,N0,N0,N0,N0,N0,N0,N0,N0,S(32)" />
        <signal name="res(31:0)" />
        <signal name="zero" />
        <signal name="overflow" />
        <signal name="N0" />
        <signal name="S(32)" />
        <signal name="XLXN_20(31:0)" />
        <port polarity="Input" name="ALU_operation(2:0)" />
        <port polarity="Input" name="A(31:0)" />
        <port polarity="Input" name="B(31:0)" />
        <port polarity="Output" name="res(31:0)" />
        <port polarity="Output" name="zero" />
        <port polarity="Output" name="overflow" />
        <blockdef name="and32">
            <timestamp>2016-2-25T16:29:0</timestamp>
            <line x2="32" y1="-96" y2="-96" style="linewidth:W" x1="64" />
            <line x2="28" y1="-32" y2="-32" style="linewidth:W" x1="64" />
            <line x2="64" y1="-16" y2="-16" x1="144" />
            <line x2="64" y1="-16" y2="-112" x1="64" />
            <line x2="144" y1="-112" y2="-112" x1="64" />
            <arc ex="144" ey="-112" sx="144" sy="-16" r="48" cx="144" cy="-64" />
            <line x2="224" y1="-64" y2="-64" style="linewidth:W" x1="192" />
        </blockdef>
        <blockdef name="ADC32">
            <timestamp>2016-2-25T16:29:0</timestamp>
            <line x2="48" y1="-256" y2="-256" style="linewidth:W" x1="64" />
            <line x2="48" y1="-128" y2="-128" style="linewidth:W" x1="64" />
            <line x2="64" y1="-224" y2="-300" x1="64" />
            <line x2="112" y1="-224" y2="-192" x1="64" />
            <line x2="112" y1="-160" y2="-192" x1="64" />
            <line x2="64" y1="-160" y2="-76" x1="64" />
            <line x2="224" y1="-76" y2="-140" x1="64" />
            <line x2="224" y1="-300" y2="-236" x1="64" />
            <line x2="224" y1="-140" y2="-236" x1="224" />
            <line x2="240" y1="-192" y2="-192" style="linewidth:W" x1="224" />
            <line x2="128" y1="-304" y2="-276" x1="128" />
        </blockdef>
        <blockdef name="xor32">
            <timestamp>2016-2-25T16:29:0</timestamp>
            <arc ex="80" ey="-112" sx="80" sy="-16" r="56" cx="48" cy="-64" />
            <line x2="80" y1="-112" y2="-112" x1="144" />
            <line x2="80" y1="-16" y2="-16" x1="144" />
            <arc ex="144" ey="-112" sx="224" sy="-64" r="88" cx="148" cy="-24" />
            <arc ex="60" ey="-112" sx="64" sy="-16" r="56" cx="32" cy="-64" />
            <arc ex="224" ey="-64" sx="144" sy="-16" r="88" cx="148" cy="-104" />
            <line x2="80" y1="-96" y2="-96" style="linewidth:W" x1="32" />
            <line x2="80" y1="-32" y2="-32" style="linewidth:W" x1="32" />
            <line x2="228" y1="-64" y2="-64" style="linewidth:W" x1="256" />
        </blockdef>
        <blockdef name="nor32">
            <timestamp>2016-2-25T16:29:0</timestamp>
            <line x2="64" y1="-112" y2="-112" x1="128" />
            <arc ex="64" ey="-112" sx="64" sy="-16" r="56" cx="32" cy="-64" />
            <line x2="64" y1="-16" y2="-16" x1="128" />
            <arc ex="208" ey="-64" sx="128" sy="-16" r="88" cx="132" cy="-104" />
            <arc ex="128" ey="-112" sx="208" sy="-64" r="88" cx="132" cy="-24" />
            <line x2="224" y1="-64" y2="-64" style="linewidth:W" x1="256" />
            <circle style="linewidth:W" r="8" cx="216" cy="-64" />
            <line x2="48" y1="-96" y2="-96" style="linewidth:W" x1="80" />
            <line x2="48" y1="-32" y2="-32" style="linewidth:W" x1="80" />
        </blockdef>
        <blockdef name="srl32">
            <timestamp>2016-2-25T16:29:0</timestamp>
            <rect width="184" x="64" y="-128" height="128" />
            <line x2="32" y1="-96" y2="-96" style="linewidth:W" x1="64" />
            <line x2="32" y1="-32" y2="-32" style="linewidth:W" x1="64" />
            <line x2="288" y1="-64" y2="-64" style="linewidth:W" x1="248" />
        </blockdef>
        <blockdef name="MUX8T1_32">
            <timestamp>2016-2-25T16:29:0</timestamp>
            <rect width="68" x="12" y="-264" height="264" />
            <line x2="48" y1="-264" y2="-272" style="linewidth:W" x1="48" />
            <line x2="0" y1="-16" y2="-16" style="linewidth:W" x1="12" />
            <line x2="0" y1="-48" y2="-48" style="linewidth:W" x1="12" />
            <line x2="0" y1="-80" y2="-80" style="linewidth:W" x1="12" />
            <line x2="0" y1="-112" y2="-112" style="linewidth:W" x1="12" />
            <line x2="0" y1="-144" y2="-144" style="linewidth:W" x1="12" />
            <line x2="0" y1="-176" y2="-176" style="linewidth:W" x1="12" />
            <line x2="0" y1="-208" y2="-208" style="linewidth:W" x1="12" />
            <line x2="0" y1="-240" y2="-240" style="linewidth:W" x1="12" />
            <line x2="96" y1="-160" y2="-160" style="linewidth:W" x1="80" />
        </blockdef>
        <blockdef name="or_bit_32">
            <timestamp>2016-2-25T16:29:0</timestamp>
            <rect width="220" x="64" y="-104" height="112" />
            <line x2="32" y1="-48" y2="-48" style="linewidth:W" x1="64" />
            <arc ex="260" ey="-48" sx="180" sy="0" r="88" cx="184" cy="-88" />
            <line x2="116" y1="0" y2="0" x1="180" />
            <line x2="116" y1="-96" y2="-96" x1="180" />
            <arc ex="116" ey="-96" sx="116" sy="0" r="56" cx="84" cy="-48" />
            <arc ex="180" ey="-96" sx="260" sy="-48" r="88" cx="184" cy="-8" />
            <line x2="120" y1="-96" y2="-96" x1="184" />
            <line x2="88" y1="-80" y2="-80" x1="128" />
            <line x2="92" y1="-16" y2="-16" x1="132" />
            <line x2="304" y1="-48" y2="-48" x1="284" />
        </blockdef>
        <blockdef name="SignalExt_32">
            <timestamp>2016-2-25T16:29:0</timestamp>
            <line x2="76" y1="-32" y2="-32" x1="64" />
            <line x2="208" y1="-32" y2="-32" style="linewidth:W" x1="196" />
            <rect width="120" x="76" y="-52" height="40" />
        </blockdef>
        <blockdef name="gnd">
            <timestamp>2000-1-1T10:10:10</timestamp>
            <line x2="64" y1="-64" y2="-96" x1="64" />
            <line x2="52" y1="-48" y2="-48" x1="76" />
            <line x2="60" y1="-32" y2="-32" x1="68" />
            <line x2="40" y1="-64" y2="-64" x1="88" />
            <line x2="64" y1="-64" y2="-80" x1="64" />
            <line x2="64" y1="-128" y2="-96" x1="64" />
        </blockdef>
        <blockdef name="buf">
            <timestamp>2000-1-1T10:10:10</timestamp>
            <line x2="64" y1="-32" y2="-32" x1="0" />
            <line x2="128" y1="-32" y2="-32" x1="224" />
            <line x2="128" y1="0" y2="-32" x1="64" />
            <line x2="64" y1="-32" y2="-64" x1="128" />
            <line x2="64" y1="-64" y2="0" x1="64" />
        </blockdef>
        <blockdef name="or32">
            <timestamp>2016-2-25T16:29:0</timestamp>
            <line x2="64" y1="-16" y2="-16" x1="128" />
            <arc ex="208" ey="-64" sx="128" sy="-16" r="88" cx="132" cy="-104" />
            <arc ex="128" ey="-112" sx="208" sy="-64" r="88" cx="132" cy="-24" />
            <line x2="236" y1="-64" y2="-64" style="linewidth:W" x1="208" />
            <line x2="64" y1="-112" y2="-112" x1="128" />
            <line x2="48" y1="-96" y2="-96" style="linewidth:W" x1="80" />
            <arc ex="64" ey="-112" sx="64" sy="-16" r="56" cx="32" cy="-64" />
            <line x2="48" y1="-32" y2="-32" style="linewidth:W" x1="80" />
        </blockdef>
        <block symbolname="and32" name="ALU_U1">
            <blockpin signalname="XLXN_3(31:0)" name="res(31:0)" />
            <blockpin signalname="A(31:0)" name="A(31:0)" />
            <blockpin signalname="B(31:0)" name="B(31:0)" />
        </block>
        <block symbolname="ADC32" name="ALU_U2">
            <blockpin signalname="XLXN_15(31:0)" name="B(31:0)" />
            <blockpin signalname="A(31:0)" name="A(31:0)" />
            <blockpin signalname="ALU_operation(2)" name="C0" />
            <blockpin signalname="S(32:0)" name="S(32:0)" />
        </block>
        <block symbolname="xor32" name="ALU_U3">
            <blockpin signalname="A(31:0)" name="A(31:0)" />
            <blockpin signalname="B(31:0)" name="B(31:0)" />
            <blockpin signalname="XLXN_16(31:0)" name="res(31:0)" />
        </block>
        <block symbolname="nor32" name="ALU_U4">
            <blockpin signalname="XLXN_17(31:0)" name="res(31:0)" />
            <blockpin signalname="A(31:0)" name="A(31:0)" />
            <blockpin signalname="B(31:0)" name="B(31:0)" />
        </block>
        <block symbolname="srl32" name="ALU_U5">
            <blockpin signalname="A(31:0)" name="A(31:0)" />
            <blockpin signalname="B(31:0)" name="B(31:0)" />
            <blockpin signalname="XLXN_18(31:0)" name="res(31:0)" />
        </block>
        <block symbolname="MUX8T1_32" name="MUXALU">
            <blockpin signalname="ALU_operation(2:0)" name="s(2:0)" />
            <blockpin signalname="N0,N0,N0,N0,N0,N0,N0,N0,N0,N0,N0,N0,N0,N0,N0,N0,N0,N0,N0,N0,N0,N0,N0,N0,N0,N0,N0,N0,N0,N0,N0,S(32)" name="I7(31:0)" />
            <blockpin signalname="S(31:0)" name="I6(31:0)" />
            <blockpin signalname="XLXN_18(31:0)" name="I5(31:0)" />
            <blockpin signalname="XLXN_17(31:0)" name="I4(31:0)" />
            <blockpin signalname="XLXN_16(31:0)" name="I3(31:0)" />
            <blockpin signalname="S(31:0)" name="I2(31:0)" />
            <blockpin signalname="XLXN_20(31:0)" name="I1(31:0)" />
            <blockpin signalname="XLXN_3(31:0)" name="I0(31:0)" />
            <blockpin signalname="res(31:0)" name="o(31:0)" />
        </block>
        <block symbolname="or_bit_32" name="ALU_Zero">
            <blockpin signalname="zero" name="o" />
            <blockpin signalname="res(31:0)" name="A(31:0)" />
        </block>
        <block symbolname="SignalExt_32" name="Signal1_32">
            <blockpin signalname="XLXN_13(31:0)" name="So(31:0)" />
            <blockpin signalname="ALU_operation(2)" name="S" />
        </block>
        <block symbolname="xor32" name="ALU_U7">
            <blockpin signalname="XLXN_13(31:0)" name="A(31:0)" />
            <blockpin signalname="B(31:0)" name="B(31:0)" />
            <blockpin signalname="XLXN_15(31:0)" name="res(31:0)" />
        </block>
        <block symbolname="gnd" name="GND1">
            <blockpin signalname="N0" name="G" />
        </block>
        <block symbolname="buf" name="XLXI_4">
            <blockpin signalname="S(32)" name="I" />
            <blockpin signalname="overflow" name="O" />
        </block>
        <block symbolname="or32" name="ALU_U6">
            <blockpin signalname="XLXN_20(31:0)" name="res(31:0)" />
            <blockpin signalname="A(31:0)" name="A(31:0)" />
            <blockpin signalname="B(31:0)" name="B(31:0)" />
        </block>
    </netlist>
    <sheet sheetnum="1" width="3520" height="2720">
        <instance x="1152" y="1168" name="ALU_U2" orien="R0">
        </instance>
        <instance x="1152" y="1264" name="ALU_U3" orien="R0">
        </instance>
        <instance x="1136" y="1424" name="ALU_U4" orien="R0">
        </instance>
        <instance x="2064" y="992" name="MUXALU" orien="R0">
        </instance>
        <branch name="ALU_operation(2:0)">
            <wire x2="768" y1="304" y2="304" x1="704" />
            <wire x2="2112" y1="304" y2="304" x1="768" />
            <wire x2="2112" y1="304" y2="720" x1="2112" />
            <wire x2="768" y1="304" y2="352" x1="768" />
        </branch>
        <iomarker fontsize="28" x="704" y="304" name="ALU_operation(2:0)" orien="R180" />
        <bustap x2="768" y1="352" y2="448" x1="768" />
        <branch name="XLXN_3(31:0)">
            <wire x2="1744" y1="544" y2="544" x1="1392" />
            <wire x2="1744" y1="544" y2="752" x1="1744" />
            <wire x2="2064" y1="752" y2="752" x1="1744" />
        </branch>
        <iomarker fontsize="28" x="544" y="1616" name="B(31:0)" orien="R180" />
        <iomarker fontsize="28" x="560" y="544" name="A(31:0)" orien="R180" />
        <branch name="B(31:0)">
            <wire x2="528" y1="1072" y2="1072" x1="432" />
            <wire x2="432" y1="1072" y2="1392" x1="432" />
            <wire x2="992" y1="1392" y2="1392" x1="432" />
            <wire x2="992" y1="1392" y2="1616" x1="992" />
            <wire x2="1168" y1="1616" y2="1616" x1="992" />
            <wire x2="1184" y1="1392" y2="1392" x1="992" />
            <wire x2="992" y1="1616" y2="1616" x1="544" />
            <wire x2="1200" y1="576" y2="576" x1="992" />
            <wire x2="992" y1="576" y2="768" x1="992" />
            <wire x2="992" y1="768" y2="1232" x1="992" />
            <wire x2="992" y1="1232" y2="1392" x1="992" />
            <wire x2="1184" y1="1232" y2="1232" x1="992" />
            <wire x2="1232" y1="768" y2="768" x1="992" />
        </branch>
        <instance x="1168" y="608" name="ALU_U1" orien="R0">
        </instance>
        <bustap x2="1552" y1="976" y2="976" x1="1456" />
        <branch name="S(32:0)">
            <wire x2="1456" y1="976" y2="976" x1="1392" />
        </branch>
        <branch name="S(31:0)">
            <attrtext style="alignment:SOFT-LEFT;fontsize:28;fontname:Arial" attrname="Name" x="1820" y="816" type="branch" />
            <attrtext style="alignment:SOFT-LEFT;fontsize:28;fontname:Arial" attrname="Name" x="1880" y="944" type="branch" />
            <wire x2="1616" y1="976" y2="976" x1="1552" />
            <wire x2="1744" y1="976" y2="976" x1="1616" />
            <wire x2="1616" y1="816" y2="976" x1="1616" />
            <wire x2="2064" y1="816" y2="816" x1="1616" />
            <wire x2="1744" y1="944" y2="976" x1="1744" />
            <wire x2="2064" y1="944" y2="944" x1="1744" />
        </branch>
        <branch name="ALU_operation(2)">
            <attrtext style="alignment:SOFT-LEFT;fontsize:28;fontname:Arial" attrname="Name" x="919" y="848" type="branch" />
            <wire x2="768" y1="848" y2="848" x1="640" />
            <wire x2="1280" y1="848" y2="848" x1="768" />
            <wire x2="1280" y1="848" y2="864" x1="1280" />
            <wire x2="768" y1="448" y2="848" x1="768" />
        </branch>
        <instance x="704" y="816" name="Signal1_32" orien="R180">
        </instance>
        <instance x="496" y="1104" name="ALU_U7" orien="R0">
        </instance>
        <branch name="XLXN_13(31:0)">
            <wire x2="496" y1="848" y2="848" x1="416" />
            <wire x2="416" y1="848" y2="1008" x1="416" />
            <wire x2="528" y1="1008" y2="1008" x1="416" />
        </branch>
        <branch name="XLXN_15(31:0)">
            <wire x2="1200" y1="1040" y2="1040" x1="752" />
        </branch>
        <branch name="XLXN_16(31:0)">
            <wire x2="1648" y1="1200" y2="1200" x1="1408" />
            <wire x2="2064" y1="848" y2="848" x1="1648" />
            <wire x2="1648" y1="848" y2="1200" x1="1648" />
        </branch>
        <branch name="XLXN_17(31:0)">
            <wire x2="1680" y1="1360" y2="1360" x1="1392" />
            <wire x2="2064" y1="880" y2="880" x1="1680" />
            <wire x2="1680" y1="880" y2="1360" x1="1680" />
        </branch>
        <branch name="XLXN_18(31:0)">
            <wire x2="1712" y1="1584" y2="1584" x1="1424" />
            <wire x2="1712" y1="912" y2="1584" x1="1712" />
            <wire x2="2064" y1="912" y2="912" x1="1712" />
        </branch>
        <branch name="N0,N0,N0,N0,N0,N0,N0,N0,N0,N0,N0,N0,N0,N0,N0,N0,N0,N0,N0,N0,N0,N0,N0,N0,N0,N0,N0,N0,N0,N0,N0,S(32)">
            <wire x2="2064" y1="976" y2="976" x1="1856" />
            <wire x2="1856" y1="976" y2="1168" x1="1856" />
            <wire x2="1888" y1="1168" y2="1168" x1="1856" />
        </branch>
        <branch name="N0">
            <wire x2="2016" y1="1216" y2="1280" x1="2016" />
            <wire x2="2016" y1="1280" y2="1296" x1="2016" />
        </branch>
        <instance x="1952" y="1408" name="GND1" orien="R0" />
        <instance x="2240" y="1264" name="ALU_Zero" orien="R0">
        </instance>
        <branch name="res(31:0)">
            <wire x2="2368" y1="832" y2="832" x1="2160" />
            <wire x2="2368" y1="832" y2="1088" x1="2368" />
            <wire x2="2416" y1="832" y2="832" x1="2368" />
            <wire x2="2208" y1="1088" y2="1216" x1="2208" />
            <wire x2="2272" y1="1216" y2="1216" x1="2208" />
            <wire x2="2368" y1="1088" y2="1088" x1="2208" />
        </branch>
        <iomarker fontsize="28" x="2416" y="832" name="res(31:0)" orien="R0" />
        <branch name="zero">
            <wire x2="2576" y1="1216" y2="1216" x1="2544" />
        </branch>
        <iomarker fontsize="28" x="2576" y="1216" name="zero" orien="R0" />
        <branch name="overflow">
            <wire x2="2336" y1="1536" y2="1536" x1="2208" />
        </branch>
        <branch name="A(31:0)">
            <wire x2="1088" y1="544" y2="544" x1="560" />
            <wire x2="1088" y1="544" y2="704" x1="1088" />
            <wire x2="1088" y1="704" y2="912" x1="1088" />
            <wire x2="1200" y1="912" y2="912" x1="1088" />
            <wire x2="1088" y1="912" y2="1168" x1="1088" />
            <wire x2="1184" y1="1168" y2="1168" x1="1088" />
            <wire x2="1088" y1="1168" y2="1328" x1="1088" />
            <wire x2="1184" y1="1328" y2="1328" x1="1088" />
            <wire x2="1088" y1="1328" y2="1552" x1="1088" />
            <wire x2="1168" y1="1552" y2="1552" x1="1088" />
            <wire x2="1232" y1="704" y2="704" x1="1088" />
            <wire x2="1200" y1="512" y2="512" x1="1088" />
            <wire x2="1088" y1="512" y2="544" x1="1088" />
        </branch>
        <instance x="1136" y="1648" name="ALU_U5" orien="R0">
        </instance>
        <iomarker fontsize="28" x="2336" y="1536" name="overflow" orien="R0" />
        <instance x="1984" y="1568" name="XLXI_4" orien="R0" />
        <branch name="S(32)">
            <attrtext style="alignment:SOFT-RIGHT;fontsize:28;fontname:Arial" attrname="Name" x="1952" y="1536" type="branch" />
            <wire x2="1984" y1="1536" y2="1536" x1="1952" />
        </branch>
        <branch name="XLXN_20(31:0)">
            <wire x2="2048" y1="736" y2="736" x1="1424" />
            <wire x2="2048" y1="736" y2="784" x1="2048" />
            <wire x2="2064" y1="784" y2="784" x1="2048" />
        </branch>
        <instance x="1184" y="800" name="ALU_U6" orien="R0">
        </instance>
    </sheet>
</drawing>