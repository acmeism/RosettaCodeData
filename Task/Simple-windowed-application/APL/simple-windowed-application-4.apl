<?xml version="1.0" encoding="UTF-8"?>
<!-- Generated with glade 3.22.1 -->
<interface>
  <requires lib="gtk+" version="3.20"/>
  <object class="GtkWindow" id="window1">
    <property name="can_focus">False</property>
    <child>
      <placeholder/>
    </child>
    <child>
      <object class="GtkGrid" id="grid1">
        <property name="visible">True</property>
        <property name="can_focus">False</property>
        <property name="row_homogeneous">True</property>
        <child>
          <object class="GtkLabel" id="label1">
            <property name="name">lblEmployee</property>
            <property name="visible">True</property>
            <property name="can_focus">False</property>
            <property name="label" translatable="yes">Employee</property>
            <property name="wrap">True</property>
          </object>
          <packing>
            <property name="left_attach">1</property>
            <property name="top_attach">1</property>
          </packing>
        </child>
        <child>
          <object class="GtkLabel" id="label2">
            <property name="name">lblPosition</property>
            <property name="visible">True</property>
            <property name="can_focus">False</property>
            <property name="label" translatable="yes">Position</property>
          </object>
          <packing>
            <property name="left_attach">1</property>
            <property name="top_attach">2</property>
          </packing>
        </child>
        <child>
          <object class="GtkEntry" id="entry1">
            <property name="name">entryEmployee</property>
            <property name="visible">True</property>
            <property name="can_focus">True</property>
            <property name="valign">center</property>
          </object>
          <packing>
            <property name="left_attach">3</property>
            <property name="top_attach">1</property>
            <property name="width">6</property>
          </packing>
        </child>
        <child>
          <object class="GtkEntry" id="entry2">
            <property name="name">entryPosition</property>
            <property name="visible">True</property>
            <property name="can_focus">True</property>
            <property name="valign">center</property>
          </object>
          <packing>
            <property name="left_attach">3</property>
            <property name="top_attach">2</property>
            <property name="width">6</property>
          </packing>
        </child>
        <child>
          <object class="GtkButton" id="btnOK">
            <property name="label" translatable="yes">button</property>
            <property name="name">OK-button</property>
            <property name="visible">True</property>
            <property name="can_focus">True</property>
            <property name="receives_default">True</property>
            <signal name="clicked" handler="clicked" swapped="no"/>
            <style>
              <class name="BUTTON"/>
            </style>
          </object>
          <packing>
            <property name="left_attach">4</property>
            <property name="top_attach">4</property>
            <property name="width">2</property>
          </packing>
        </child>
      </object>
    </child>
  </object>
</interface>
