/****************************************************************************
** Meta object code from reading C++ file 'population.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.2.0)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../sources/model/population.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'population.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.2.0. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
struct qt_meta_stringdata_Population_t {
    QByteArrayData data[13];
    char stringdata[169];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    offsetof(qt_meta_stringdata_Population_t, stringdata) + ofs \
        - idx * sizeof(QByteArrayData) \
    )
static const qt_meta_stringdata_Population_t qt_meta_stringdata_Population = {
    {
QT_MOC_LITERAL(0, 0, 10),
QT_MOC_LITERAL(1, 11, 21),
QT_MOC_LITERAL(2, 33, 0),
QT_MOC_LITERAL(3, 34, 10),
QT_MOC_LITERAL(4, 45, 7),
QT_MOC_LITERAL(5, 53, 5),
QT_MOC_LITERAL(6, 59, 6),
QT_MOC_LITERAL(7, 66, 8),
QT_MOC_LITERAL(8, 75, 16),
QT_MOC_LITERAL(9, 92, 24),
QT_MOC_LITERAL(10, 117, 23),
QT_MOC_LITERAL(11, 141, 14),
QT_MOC_LITERAL(12, 156, 11)
    },
    "Population\0getIndividualProperty\0\0"
    "generation\0cluster\0index\0findex\0"
    "property\0getNbGenerations\0"
    "getMaxNbIndPerGeneration\0"
    "getNbObjectiveFunctions\0getGenerations\0"
    "Generation*\0"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_Population[] = {

 // content:
       7,       // revision
       0,       // classname
       0,    0, // classinfo
       5,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       0,       // signalCount

 // methods: name, argc, parameters, tag, flags
       1,    5,   39,    2, 0x02,
       8,    0,   50,    2, 0x02,
       9,    0,   51,    2, 0x02,
      10,    0,   52,    2, 0x02,
      11,    1,   53,    2, 0x02,

 // methods: parameters
    QMetaType::QVariant, QMetaType::Int, QMetaType::Int, QMetaType::Int, QMetaType::Int, QMetaType::Int,    3,    4,    5,    6,    7,
    QMetaType::Int,
    QMetaType::Int,
    QMetaType::Int,
    0x80000000 | 12, QMetaType::Int,    5,

       0        // eod
};

void Population::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        Population *_t = static_cast<Population *>(_o);
        switch (_id) {
        case 0: { QVariant _r = _t->getIndividualProperty((*reinterpret_cast< int(*)>(_a[1])),(*reinterpret_cast< int(*)>(_a[2])),(*reinterpret_cast< int(*)>(_a[3])),(*reinterpret_cast< int(*)>(_a[4])),(*reinterpret_cast< int(*)>(_a[5])));
            if (_a[0]) *reinterpret_cast< QVariant*>(_a[0]) = _r; }  break;
        case 1: { int _r = _t->getNbGenerations();
            if (_a[0]) *reinterpret_cast< int*>(_a[0]) = _r; }  break;
        case 2: { int _r = _t->getMaxNbIndPerGeneration();
            if (_a[0]) *reinterpret_cast< int*>(_a[0]) = _r; }  break;
        case 3: { int _r = _t->getNbObjectiveFunctions();
            if (_a[0]) *reinterpret_cast< int*>(_a[0]) = _r; }  break;
        case 4: { Generation* _r = _t->getGenerations((*reinterpret_cast< int(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< Generation**>(_a[0]) = _r; }  break;
        default: ;
        }
    }
}

const QMetaObject Population::staticMetaObject = {
    { &QObject::staticMetaObject, qt_meta_stringdata_Population.data,
      qt_meta_data_Population,  qt_static_metacall, 0, 0}
};


const QMetaObject *Population::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *Population::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_Population.stringdata))
        return static_cast<void*>(const_cast< Population*>(this));
    return QObject::qt_metacast(_clname);
}

int Population::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 5)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 5;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 5)
            *reinterpret_cast<int*>(_a[0]) = -1;
        _id -= 5;
    }
    return _id;
}
QT_END_MOC_NAMESPACE
